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

  def clock = DateTime.now.getMillis - startTime.getMillis

  var state = PlayerState.initial(player)
  var input = PlayerInput.initial

  var playerRef: Option[ActorRef] = None

  var ghostRuns = Seq.empty[GhostRun]

  def started = clock >= 0
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
      Tracking.pushPoint(run.id, clock / 1000, newState.position)
      if (prevState.crossedGates != newState.crossedGates) updateTally()
    }

  }

  def updateTally() = {
    val finishTime = if (finished) state.crossedGates.headOption else None
    TimeTrialRun.updateTimes(run.id, state.crossedGates, finishTime)
  }
  
  def currentGhosts = {
    val second = clock / 1000
    val frame = ((clock % 1000) / Conf.fps).toInt
    val idx = if (frame > 0) frame else frame + Conf.fps
    ghostRuns.flatMap { case GhostRun(gRun, track, playerHandle) =>
      track.get(second).flatMap { frames =>
        if (frames.isDefinedAt(idx)) Some(GhostState(frames(idx), playerHandle))
        else None
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
