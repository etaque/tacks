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

case class RaceCourse(
  _id: BSONObjectID,
  course: Course,
  countdown: Int,
  startCycle: Int
) extends HasId

case class Run(
  id: BSONObjectID = BSONObjectID.generate,
  startTime: DateTime,
  leaderboard: Seq[PlayerTally]
)

case class RaceCourseState(
  nextRun: Run,
  liveRuns: Seq[Run]
) {
  def leaderboardFor(runId: BSONObjectID): Seq[PlayerTally] = {
    liveRuns.find(_.id == runId).map(_.leaderboard).getOrElse(Nil)
  }
}

case object SpawnRun

class RaceCourseActor(raceCourse: RaceCourse) extends Actor with ManageWind {

  val id = BSONObjectID.generate
  val course = raceCourse.course

  var state = RaceCourseState(
    nextRun = Run(
      startTime = DateTime.now.plusSeconds(raceCourse.countdown),
      leaderboard = Nil
    ),
    liveRuns = Nil
  )

  val players = scala.collection.mutable.Map[String, PlayerContext]()

  def clock: Long = DateTime.now.getMillis

  val spawnRunTick = Akka.system.scheduler.schedule(
    raceCourse.startCycle.seconds, raceCourse.startCycle.seconds, self, SpawnRun)

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
        // if (input.startCountdown) {
        //   raceState = RaceActor.startCountdown(raceState, byPlayerId = player.id)
        // }
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

    case SpawnRun => {
      state = RaceCourseActor.spawnRun(state)
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
      startTime = Some(state.nextRun.startTime),
      wind = wind,
      opponents = opponentsTo(player.id.stringify),
      leaderboard = leaderboardFor(player.id.stringify),
      clientTime = clientTime
    )
  }
}

object RaceCourseActor {
  def props(raceCourse: RaceCourse) = Props(new RaceCourseActor(raceCourse))

  def spawnRun(state: RaceCourseState): RaceCourseState = {
    state
  }

  def updateTally(state: RaceCourseState, playerStates: Seq[Opponent]): RaceCourseState = {
    state
  }
}
