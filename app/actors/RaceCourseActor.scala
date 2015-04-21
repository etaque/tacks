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

case class Run(
  id: BSONObjectID = BSONObjectID.generate,
  startTime: DateTime,
  leaderboard: Seq[PlayerTally]
)

case class RaceCourseState(
  raceCourse: RaceCourse,
  nextRun: Option[Run],
  liveRuns: Seq[Run]
) {
  def leaderboardFor(runId: BSONObjectID): Seq[PlayerTally] = {
    liveRuns.find(_.id == runId).map(_.leaderboard).getOrElse(Nil)
  }
}

case object RotateNextRun

class RaceCourseActor(raceCourse: RaceCourse) extends Actor with ManageWind {

  val id = BSONObjectID.generate
  val course = raceCourse.course

  var state = RaceCourseState(
    raceCourse = raceCourse,
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
        if (input.startCountdown) {
          state = RaceCourseActor.startCountdown(state, byPlayerId = player.id)
        }
        players += (id -> context.copy(input = input, state = opState))
        if (context.state.crossedGates != opState.crossedGates) {
          // TODO
          state = RaceCourseActor.updateTally(state, players.values.map(_.asOpponent).toSeq)
          // Race.updateFromState(raceState)
        }
        context.ref ! raceUpdateForPlayer(player, clientTime)
      }
    }

    /**
     * new gust
     */
    case SpawnGust => generateGust()

    case RotateNextRun => {
      state = RaceCourseActor.rotateNextRun(state)
    }
  }

  def opponentsTo(playerId: String): Seq[Opponent] = {
    players.toSeq.filterNot(_._1 == playerId).map(_._2.asOpponent)
  }

  def leaderboardFor(playerId: String): Seq[PlayerTally] = {
    players.get(playerId).flatMap(_.state.runId).map(state.leaderboardFor).getOrElse(Nil)
  }

  def raceUpdateForPlayer(player: Player, clientTime: Long) = {
    RaceUpdate(
      serverNow = DateTime.now,
      startTime = state.nextRun.map(_.startTime),
      wind = wind,
      opponents = opponentsTo(player.id.stringify),
      leaderboard = leaderboardFor(player.id.stringify),
      clientTime = clientTime
    )
  }

  override def postStop() = {
    ticks.foreach(_.cancel())
  }
}

object RaceCourseActor {
  def props(raceCourse: RaceCourse) = Props(new RaceCourseActor(raceCourse))

  def rotateNextRun(state: RaceCourseState): RaceCourseState = {
    state.nextRun match {
      case Some(nextRun) if nextRun.startTime.plusSeconds(state.raceCourse.countdown).isBeforeNow => {
        state.copy(nextRun = None, liveRuns = state.liveRuns :+ nextRun)
      }
      case _ => state
    }
  }

  def updateTally(state: RaceCourseState, playerStates: Seq[Opponent]): RaceCourseState = {
    // TODO
    state
  }

  def startCountdown(state: RaceCourseState, byPlayerId: BSONObjectID): RaceCourseState = {
    state.nextRun match {
      case None => {
        val run = Run(
          startTime = DateTime.now.plusSeconds(state.raceCourse.countdown),
          leaderboard = Nil
        )
        state.copy(nextRun = Some(run))
      }
      case Some(_) => state
    }
  }
}
