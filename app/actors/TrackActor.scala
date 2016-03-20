package actors

import java.util.UUID
import scala.concurrent.duration._
import scala.concurrent.Future
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import akka.actor._
import akka.pattern.pipe
import org.joda.time.DateTime

import models._
import dao._
import tools.Conf


case class TrackState(
  track: Track,
  races: Seq[Race]
) {
  def raceTallies(raceId: UUID): Seq[PlayerTally] = {
    races.find(_.id == raceId).map(_.tallies).getOrElse(Nil)
  }

  def playerRace(playerId: UUID): Option[Race] = {
    races.find(_.hasPlayer(playerId)).orElse(races.headOption)
  }

  def withUpdatedRace(race: Race): TrackState = {
    races.indexWhere(_.id == race.id) match {
      case -1 => this
      case i => copy(races = races.updated(i, race))
    }
  }

  def escapePlayer(playerId: UUID): TrackState = {
    copy(
      races = races.map(_.removePlayerId(playerId))
    )
  }
}

case class PlayerContext(
  player: Player,
  input: KeyboardInput,
  state: OpponentState,
  ref: ActorRef
) {
  def asOpponent = Opponent(state, player)
}

case class PlayerJoin(player: Player)
case class PlayerQuit(player: Player)

case class AddGhost(player: Player, runId: UUID)
case class InitGhost(player: Player, run: Run, path: RunPath)
case class RemoveGhost(player: Player, runId: UUID)

case object FrameTick
case object SpawnGust
case object GetStatus
case object AutoClean
case object RotateNextRace
case object NoOp

class TrackActor(trackInit: Track) extends Actor with ManageWind {

  val creationTime = trackInit.creationTime

  var state = TrackState(
    track = trackInit,
    races = Nil
  )

  def track = state.track
  def course = track.course

  type PlayerId = UUID
  type RunId = UUID

  val players = scala.collection.mutable.Map[PlayerId, PlayerContext]()
  val paths = scala.collection.mutable.Map[PlayerId, RunPath]()
  val playersGhosts = scala.collection.mutable.Map[PlayerId, Map[RunId, GhostState]]()
  val ghostRuns = scala.collection.mutable.Map[RunId, (Run, RunPath)]()

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
          if (track.status == TrackStatus.open && race.startTime.plusMinutes(10).isAfterNow) { // max 10min de trace
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

    case AddGhost(player, runId) =>
      ghostRuns.get(runId) match {
        case Some((run, path)) =>
          self ! InitGhost(player, run, path)
        case None =>
          val initMaybeFu = for {
            runOpt <- Runs.findById(runId)
            pathOpt <- RunPaths.findByRunId(runId)
          } yield for {
            run <- runOpt
            path <- pathOpt
          } yield InitGhost(player, run, path)
          initMaybeFu.map(_.getOrElse(NoOp)) pipeTo self
      }

    case InitGhost(player, run, path) =>
      val all = playersGhosts.getOrElse(player.id, Map.empty)
      val g = GhostState.initial(run.playerId, run.playerHandle, run.tally)
      playersGhosts += player.id -> (all + (run.id -> g))
      ghostRuns += run.id -> (run, path)

    case RemoveGhost(player, runId) =>
      playersGhosts.get(player.id).foreach { runIds =>
        playersGhosts += (player.id -> (runIds - runId))
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

    case NoOp =>
  }

  def broadcastLiveTrackUpdate(): Future[LiveTrackUpdate] = {
    trackMeta(track).map { meta =>
      LiveTrackUpdate(LiveTrack(track, meta, state.races, players.values.map(_.player).toSeq))
    } pipeTo self
  }

  def playerOpponents(playerId: UUID): Seq[Opponent] = {
    players.toSeq.filterNot(_._1 == playerId).map(_._2.asOpponent)
  }

  def playerGhosts(playerId: UUID)(ts: Long): Seq[GhostState] = {
    playersGhosts.get(playerId).map { runIds =>
      runIds.toSeq.flatMap { case (runId, ghostState) =>
        ghostRuns.get(runId).map { case (_, path) =>
          GhostState.at(ts, path)(ghostState)
        }
      }
    }.getOrElse(Nil)
  }

  def playerTallies(playerId: UUID): Seq[PlayerTally] = {
    state.playerRace(playerId).map(_.id).map(state.raceTallies).getOrElse(Nil)
  }

  def raceUpdateForPlayer(player: Player, clientTime: Long) = {
    val now = DateTime.now
    val startTimeOpt = TrackActor.playerStartTime(state, player)
    val raceTimeOpt = startTimeOpt.map(now.getMillis - _.getMillis)
    val ghosts = raceTimeOpt.map(playerGhosts(player.id)).getOrElse(Nil)
    RaceUpdate(
      serverNow = now,
      startTime = startTimeOpt,
      wind = wind,
      opponents = playerOpponents(player.id),
      ghosts = ghosts,
      tallies = playerTallies(player.id),
      clientTime = clientTime.toFloat
    )
  }

  override def postStop() = {
    ticks.foreach(_.cancel())
  }
}

object TrackActor {
  def props(track: Track) = Props(new TrackActor(track))

  def tracePlayer(ctx: PlayerContext, race: Race, paths: Map[UUID, RunPath], clock: Long): RunPath = {
    val playerId = ctx.player.id
    val elapsedMillis = clock - race.startTime.getMillis
    val currentSecond = elapsedMillis / 1000

    val p = PathPoint((elapsedMillis % 1000).toInt, ctx.state.position, ctx.state.heading)

    paths.get(playerId)
      .map(_.addPoint(currentSecond, p))
      .getOrElse(RunPath.init(currentSecond, p))
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

  def gateCrossedUpdate(state: TrackState, context: PlayerContext, playerContexts: Map[UUID, PlayerContext]): TrackState = {
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

  def startCountdown(state: TrackState, byPlayerId: UUID): TrackState = {
    state.races.headOption match {
      case Some(race) if !raceIsClosed(race, state.track) => {
        state
      }
      case _ => {
        val newRace = Race(
          id = UUID.randomUUID(),
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
      val runId = pathMaybe.map(_.runId).getOrElse(UUID.randomUUID())
      val run = Run(
        id = runId,
        trackId = track.id,
        raceId = race.id,
        playerId = ctx.player.id,
        playerHandle = ctx.player.handleOpt,
        startTime = race.startTime,
        tally = ctx.state.crossedGates,
        duration = ctx.state.crossedGates.headOption.getOrElse(0)
      )
      for {
        _ <- pathMaybe.map(savePathIfBest(track.id, ctx.player.id)).getOrElse(Future.successful(()))
        _ <- Runs.save(run)
      }
      yield ()
    }
  }

  def savePathIfBest(trackId: UUID, playerId: UUID)(path: RunPath): Future[Unit] = {
    for {
      bestMaybe <- Runs.findBestOnTrackForPlayer(trackId, playerId).map(_.headOption)
      _ <- bestMaybe.map(r => RunPaths.deleteByRunId(r.id)).getOrElse(Future.successful(()))
      _ <- RunPaths.save(path)
    }
    yield ()
  }
}
