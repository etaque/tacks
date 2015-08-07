package actors

import scala.concurrent.duration._
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import akka.actor._
import reactivemongo.bson.BSONObjectID
import org.joda.time.DateTime

import models._
import tools.Conf

case class TrackState(
  track: Track,
  nextRun: Option[TrackRun],
  liveRuns: Seq[TrackRun]
) {
  def runLeaderboard(runId: BSONObjectID): Seq[PlayerTally] = {
    liveRuns.find(_.id == runId).map(_.leaderboard).getOrElse(Nil)
  }

  def playerRun(playerId: BSONObjectID): Option[TrackRun] = {
    liveRuns.find(_.playerIds.contains(playerId)).orElse(nextRun)
  }

  def withUpdatedRun(run: TrackRun): TrackState = {
    if (nextRun.map(_.id).contains(run.id)) copy(nextRun = Some(run))
    else liveRuns.indexWhere(_.id == run.id) match {
      case -1 => this
      case i => copy(liveRuns = liveRuns.updated(i, run))
    }
  }

  def escapePlayer(playerId: BSONObjectID): TrackState = {
    copy(
      nextRun = nextRun.map(_.removePlayerId(playerId)),
      liveRuns = liveRuns.map(_.removePlayerId(playerId))
    )
  }
}

case object RotateNextRun

class TrackActor(track: Track) extends Actor with ManageWind {

  val id = BSONObjectID.generate
  val course = track.course

  var state = TrackState(
    track = track,
    nextRun = None,
    liveRuns = Nil
  )

  val players = scala.collection.mutable.Map[String, PlayerContext]()

  def clock: Long = DateTime.now.getMillis

  val ticks = Seq(
    Akka.system.scheduler.schedule(1.second, 1.second, self, RotateNextRun),
    Akka.system.scheduler.schedule(0.seconds, course.gustGenerator.interval.seconds, self, SpawnGust),
    Akka.system.scheduler.schedule(0.seconds, Conf.frameMillis.milliseconds, self, FrameTick)
  )

  def receive = {

    /**
     * player join => added to context Map
     */
    case PlayerJoin(player) => {
      players += player.id.stringify -> PlayerContext(player, KeyboardInput.initial, OpponentState.initial, sender())
    }

    /**
     * player quit => removed from context Map
     */
    case PlayerQuit(player) => {
      players -= player.id.stringify
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
      val id = player.id.stringify

      players.get(id).foreach { context =>
        val newContext = context.copy(input = input, state = opState)
        players += (id -> newContext)

        if (input.startCountdown) {
          state = TrackActor.startCountdown(state, byPlayerId = player.id)
        }

        if (input.escapeRun) {
          state = state.escapePlayer(player.id)
        }

        if (context.state.crossedGates != newContext.state.crossedGates) {
          state = TrackActor.gateCrossedUpdate(state, newContext, players.toMap)
        }

        context.ref ! raceUpdateForPlayer(player, clientTime)
      }
    }

    /**
     * new gust
     */
    case SpawnGust => generateGust()

    case RotateNextRun => {
      state = TrackActor.rotateNextRun(state)
    }

    case GetStatus => {
      sender ! (state.nextRun, players.values.map(_.asOpponent))
    }
  }

  def playerOpponents(playerId: String): Seq[Opponent] = {
    players.toSeq.filterNot(_._1 == playerId).map(_._2.asOpponent)
  }

  def playerLeaderboard(playerId: String): Seq[PlayerTally] = {
    state.playerRun(BSONObjectID(playerId)).map(_.id).map(state.runLeaderboard).getOrElse(Nil)
  }

  def raceUpdateForPlayer(player: Player, clientTime: Long) = {
    RaceUpdate(
      serverNow = DateTime.now,
      startTime = TrackActor.playerStartTime(state, player),
      wind = wind,
      opponents = playerOpponents(player.id.stringify),
      leaderboard = playerLeaderboard(player.id.stringify),
      clientTime = clientTime
    )
  }

  override def postStop() = {
    ticks.foreach(_.cancel())
  }
}

object TrackActor {
  def props(track: Track) = Props(new TrackActor(track))

  def rotateNextRun(state: TrackState): TrackState = {
    state.nextRun match {
      case Some(nextRun) if nextRun.startTime.plusSeconds(state.track.countdown).isBeforeNow => {
        state.copy(nextRun = None, liveRuns = state.liveRuns :+ nextRun)
      }
      case _ => state
    }
  }

  def playerStartTime(state: TrackState, player: Player): Option[DateTime] = {
    state.playerRun(player.id).map(_.startTime)
  }

  def gateCrossedUpdate(state: TrackState, context: PlayerContext, players: Map[String,PlayerContext]): TrackState = {
    state.playerRun(context.player.id).map { run =>

      val playerIds =
        if (context.state.crossedGates.length == 1) run.playerIds :+ context.player.id
        else run.playerIds

      val leaderboard = playerIds.map(_.stringify).flatMap(players.get).map { context =>
        PlayerTally(context.player.id, context.player.handleOpt, context.state.crossedGates)
      }.sortBy { pt =>
        (-pt.gates.length, pt.gates.headOption)
      }

      val updatedRun = run.copy(playerIds = playerIds, leaderboard = leaderboard)

      TrackRun.upsert(updatedRun)

      state.withUpdatedRun(updatedRun)

    }.getOrElse(state)
  }

  def startCountdown(state: TrackState, byPlayerId: BSONObjectID): TrackState = {
    state.nextRun match {
      case None => {
        val run = TrackRun(
          _id = BSONObjectID.generate,
          trackId = state.track.id,
          startTime = DateTime.now.plusSeconds(state.track.countdown),
          playerIds = Nil,
          leaderboard = Nil
        )
        state.copy(nextRun = Some(run))
      }
      case Some(_) => state
    }
  }
}
