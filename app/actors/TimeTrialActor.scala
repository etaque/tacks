package actors

import scala.concurrent.duration._
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import akka.actor.{Props, ActorRef, Actor}
import org.joda.time.DateTime

import tools.Conf
import models._

case class SetGhostRuns(ghostRuns: Seq[GhostRun])

class TimeTrialActor(trial: TimeTrial, player: Player, run: TimeTrialRun) extends Actor with ManageWind {

  val startTime = DateTime.now.plusSeconds(trial.countdownSeconds)
  val startScheduled = true
  val course = trial.course

  def clock = DateTime.now.getMillis - startTime.getMillis + trial.countdownSeconds * 1000

  var state = PlayerState.initial(player)
  var input = PlayerInput.initial

  var playerRef: Option[ActorRef] = None

  var ghostRuns = Seq.empty[GhostRun]

  def started = startTime.isBeforeNow
  def finished = state.crossedGates.length == course.gatesToCross

  val ticks = Seq(
    Akka.system.scheduler.schedule(0.seconds, 20.seconds, self, SpawnGust),
    Akka.system.scheduler.schedule(0.seconds, Conf.frameMillis.milliseconds, self, FrameTick)
  )

  def receive = {

    /**
     * player join => keep actor ref
     */
    case PlayerJoin(_) => {
      playerRef = Some(sender())
    }

    case SetGhostRuns(runs) => {
      ghostRuns = runs
    }

    /**
     * game heartbeat:
     *  - update wind (origin, speed and gusts positions)
     *  - send a race update to players actor for websocket transmission
     *  - tell player actor to run step
     */
    case FrameTick => {
      playerRef.foreach { ref =>
        updateWind()

        ref ! raceUpdate
        ref ! RunStep(state, input, clock, wind, course, started, Nil)
      }
    }

    /**
     * new gust
     */
    case SpawnGust => generateGust()

    /**
     * player input coming from websocket through player actor
     */
    case PlayerUpdate(_, newInput) => {
      input = newInput
    }

    /**
     * step result coming from player actor
     * context is updated
     */
    case StepResult(prevState, newState) => {
      state = newState
      Tracking.pushStep(run.id, clock / 1000, TrackStep((clock % 1000).toInt, newState.position, newState.heading))
      if (prevState.crossedGates != newState.crossedGates) updateTally()
    }

  }

  def updateTally() = {
    val finishTime = if (finished) state.crossedGates.headOption else None
    TimeTrialRun.updateTimes(run.id, state.crossedGates, finishTime)
  }
  
  def currentGhosts = {
    val second = clock / 1000
    val ms = (clock % 1000).toInt
    ghostRuns.flatMap { case GhostRun(gRun, track, playerHandle) =>
      track.get(second).flatMap { frames =>
        frames.sortBy(f => math.abs(f.ms - ms)).headOption.map { s =>
          GhostState(s.position, s.heading, playerHandle)
        }
      }
    }
  }

  def raceUpdate = {
    val id = player.id.stringify
    RaceUpdate(
      playerId = id,
      now = DateTime.now,
      startTime = Some(startTime),
      course = None, // already transmitted in initial update
      playerState = Some(state),
      wind = wind,
      opponents = Nil,
      ghosts = currentGhosts,
      leaderboard = Nil,
      isMaster = true,
      watching = false
    )
  }

  override def postStop() = ticks.foreach(_.cancel())
}

object TimeTrialActor {
  def props(timeTrial: TimeTrial, player: Player, run: TimeTrialRun) = Props(new TimeTrialActor(timeTrial, player, run))
}
