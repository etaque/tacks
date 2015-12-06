package actors

import scala.concurrent.duration._
import scala.concurrent.Future
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import akka.actor._
import akka.pattern.pipe
import reactivemongo.bson.BSONObjectID
import org.joda.time.DateTime

import models._
import dao._
import tools.Conf

case class TrackState(
  track: Track,
  races: Seq[Race]
) {
  def raceTallies(raceId: BSONObjectID): Seq[PlayerTally] = {
    races.find(_.id == raceId).map(_.tallies).getOrElse(Nil)
  }

  def playerRace(playerId: BSONObjectID): Option[Race] = {
    races.find(_.hasPlayer(playerId)).orElse(races.headOption)
  }

  def withUpdatedRace(race: Race): TrackState = {
    races.indexWhere(_.id == race.id) match {
      case -1 => this
      case i => copy(races = races.updated(i, race))
    }
  }

  def escapePlayer(playerId: BSONObjectID): TrackState = {
    copy(
      races = races.map(_.removePlayerId(playerId))
    )
  }
}

case object RotateNextRace

class TrackActor(trackInit: Track) extends Actor with ManageWind {

  val id = BSONObjectID.generate

  var state = TrackState(
    track = trackInit,
    races = Nil
  )

  def track = state.track
  def course = track.course

  val players = scala.collection.mutable.Map[BSONObjectID, PlayerContext]()
  val paths = scala.collection.mutable.Map[BSONObjectID, RunPath]()

  def clock: Long = DateTime.now.getMillis

  val ticks = Seq(
    Akka.system.scheduler.schedule(1.second, 5.second, self, RotateNextRace),
    Akka.system.scheduler.schedule(0.seconds, course.gustGenerator.interval.seconds, self, SpawnGust),
    Akka.system.scheduler.schedule(0.seconds, Conf.frameMillis.milliseconds, self, FrameTick)
  )

  def receive = {

    /**
     * player join => added to context Map
     */
    case PlayerJoin(player) => {
      players += player.id -> PlayerContext(player, KeyboardInput.initial, OpponentState.initial, sender())
      broadcastLiveTrackUpdate()
    }

    /**
     * player quit => removed from context Map
     */
    case PlayerQuit(player) => {
      players -= player.id
      paths -= player.id
      broadcastLiveTrackUpdate()
    }

    /**
     * game heartbeat:
     * update wind (origin, speed and gusts positions)
     */
    case FrameTick => {
      updateWind()
    }

    /**
     * player update coming from websocket through player actor
     * context is updated, race started if requested
     */
    case PlayerUpdate(player, PlayerInput(opState, input, clientTime)) => {

      players.get(player.id).foreach { context =>
        val newContext = context.copy(input = input, state = opState)
        players += (player.id -> newContext)

        state.playerRace(player.id).foreach { race =>
          if (race.startTime.plusMinutes(10).isAfterNow) { // max 10min de trace
            paths += player.id -> TrackActor.tracePlayer(newContext, race, paths.toMap, clock)
          }
        }

        if (input.startCountdown) {
          state = TrackActor.startCountdown(state, byPlayerId = player.id)
        }

        if (input.escapeRace) {
          state = state.escapePlayer(player.id)
          paths -= player.id
        }

        if (context.state.crossedGates != newContext.state.crossedGates) {
          state = TrackActor.gateCrossedUpdate(state, newContext, players.toMap)
          state.playerRace(player.id).foreach { race =>
            TrackActor.saveIfFinished(track, race, newContext, paths.lift(newContext.player.id))
          }

          broadcastLiveTrackUpdate()
        }

        context.ref ! raceUpdateForPlayer(player, clientTime)
      }
    }

    case LiveTrackUpdate(liveTrack) => {
      players.foreach { case (_, ctx) =>
        ctx.ref ! liveTrack
      }
    }

    case msg: Message => {
      players.foreach { case (_, ctx) =>
        ctx.ref ! msg
      }
    }

    /**
     * new gust
     */
    case SpawnGust => generateGust()

    case RotateNextRace => {
      state = TrackActor.cleanStaleRaces(state)
      broadcastLiveTrackUpdate()
    }

    case GetStatus => {
      sender ! (state.races, players.values.map(_.asOpponent))
    }

    case ReloadTrack(newTrack) => {
      state = state.copy(track = newTrack)
    }
  }

  def broadcastLiveTrackUpdate(): Future[LiveTrackUpdate] = {
    trackMeta(track).map { meta =>
      LiveTrackUpdate(LiveTrack(track, meta, state.races, players.values.map(_.player).toSeq))
    } pipeTo self
  }

  def playerOpponents(playerId: BSONObjectID): Seq[Opponent] = {
    players.toSeq.filterNot(_._1 == playerId).map(_._2.asOpponent)
  }

  def playerTallies(playerId: BSONObjectID): Seq[PlayerTally] = {
    state.playerRace(playerId).map(_.id).map(state.raceTallies).getOrElse(Nil)
  }

  def raceUpdateForPlayer(player: Player, clientTime: Long) = {
    RaceUpdate(
      serverNow = DateTime.now,
      startTime = TrackActor.playerStartTime(state, player),
      wind = wind,
      opponents = playerOpponents(player.id),
      tallies = playerTallies(player.id),
      clientTime = clientTime
    )
  }

  override def postStop() = {
    ticks.foreach(_.cancel())
  }
}

object TrackActor {
  def props(track: Track) = Props(new TrackActor(track))

  def tracePlayer(ctx: PlayerContext, race: Race, paths: Map[BSONObjectID, RunPath], clock: Long): RunPath = {
    val playerId = ctx.player.id
    val elapsedMillis = clock - race.startTime.getMillis
    val currentSecond = elapsedMillis / 1000

    val p = PathPoint((elapsedMillis % 1000).toInt, ctx.state.position, ctx.state.heading)

    paths.lift(playerId) match {
      case Some(path) => {
        path.addPoint(currentSecond, p)
      }
      case None => {
        RunPath.init(currentSecond, p)
      }
    }
  }

  def cleanStaleRaces(state: TrackState): TrackState = {
    state.copy(
      races = state.races.filterNot { r =>
        raceIsClosed(r, state.track) && r.players.isEmpty
      }
    )
  }

  def playerStartTime(state: TrackState, player: Player): Option[DateTime] = {
    state.playerRace(player.id).map(_.startTime)
  }

  def gateCrossedUpdate(state: TrackState, context: PlayerContext, playerContexts: Map[BSONObjectID, PlayerContext]): TrackState = {
    state.playerRace(context.player.id).map { race =>

      val players = race.players + context.player

      val finished = context.state.hasFinished(state.track.course)
      val newTally = PlayerTally(context.player, context.state.crossedGates, finished)

      val tallies = race.tallies
        .filter(_.player.id != context.player.id) :+ newTally

      val sortedTallies = tallies.sortBy { t =>
        (-t.gates.length, t.gates.headOption)
      }

      val updatedRace = race.copy(players = players, tallies = tallies)

      state.withUpdatedRace(updatedRace)

    }.getOrElse(state)
  }

  def startCountdown(state: TrackState, byPlayerId: BSONObjectID): TrackState = {
    state.races.headOption match {
      case Some(race) if !raceIsClosed(race, state.track) => {
        state
      }
      case _ => {
        val newRace = Race(
          _id = BSONObjectID.generate,
          trackId = state.track.id,
          startTime = DateTime.now.plusSeconds(Conf.countdown),
          players = Set.empty,
          tallies = Nil
        )
        state.copy(races = newRace +: state.races)
      }
    }
  }

  def raceIsClosed(race: Race, track: Track): Boolean =
    race.startTime.plusSeconds(Conf.countdown).isBeforeNow


  def saveIfFinished(track: Track, race: Race, ctx: PlayerContext, pathMaybe: Option[RunPath]): Unit = {
    if (ctx.state.hasFinished(track.course)) {
      val runId = pathMaybe.map(_.runId).getOrElse(BSONObjectID.generate)
      val run = Run(
        _id = runId,
        trackId = track.id,
        raceId = race.id,
        playerId = ctx.player.id,
        playerHandle = ctx.player.handleOpt,
        startTime = race.startTime,
        tally = ctx.state.crossedGates,
        finishTime = ctx.state.crossedGates.head
      )
      for {
        _ <- pathMaybe.map(savePathIfBest(track.id, ctx.player.id)).getOrElse(Future.successful(()))
        _ <- RunDAO.save(run)
      }
      yield ()
    }
  }

  def savePathIfBest(trackId: BSONObjectID, playerId: BSONObjectID)(path: RunPath): Future[Unit] = {
    for {
      bestMaybe <- RunDAO.findBestOnTrackForPlayer(trackId, playerId)
      _ <- bestMaybe.map(_.id).map(RunPathDAO.deleteByRunId).getOrElse(Future.successful(()))
      _ <- RunPathDAO.save(path)
    }
    yield ()
  }
}
