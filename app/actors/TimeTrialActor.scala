package actors

import scala.concurrent.duration._
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import akka.actor.{PoisonPill, Props, ActorRef, Actor}
import org.joda.time.DateTime

import tools.Conf
import models._

case class SetGhostRuns(ghostRuns: Seq[GhostRun])

class TimeTrialActor(trial: TimeTrial, player: Player, run: TimeTrialRun) extends Actor with ManageWind {

  val id = trial.id
  val startTime = DateTime.now.plusSeconds(trial.countdownSeconds)
  val startScheduled = true
  val course = trial.course

  def clock = DateTime.now.getMillis - startTime.getMillis + trial.countdownSeconds * 1000
  def currentSecond = clock / 1000

  var activeSecond = currentSecond
  var activePoints = Seq.empty[TrackPoint]

  var state = PlayerState.initial(player)
  var input = PlayerInput.initial

  var playerRef: Option[ActorRef] = None

  var ghosts = Map.empty[GhostRun, GhostState]

  def started = startTime.isBeforeNow
  def finished = state.crossedGates.length == course.gatesToCross
  var finishTime: Option[Long] = None

  val frameTick = Akka.system.scheduler.schedule(0.seconds, Conf.frameMillis.milliseconds, self, FrameTick)
  val gustsTick = Akka.system.scheduler.schedule(0.seconds, course.gustGenerator.interval.seconds, self, SpawnGust)
  val cleanTick = Akka.system.scheduler.schedule(10.seconds, 10.seconds, self, AutoClean)

  val ticks = Seq(cleanTick, gustsTick, frameTick)

  def shouldSaveRun = player.isInstanceOf[User]

  if (shouldSaveRun) TimeTrialRun.save(run)

  def receive = {

    /**
     * player join => keep actor ref
     */
    case PlayerJoin(_) => {
      playerRef = Some(sender())
    }

    case SetGhostRuns(runs) => {
      ghosts = runs.map(r => (r, GhostState.initial(r.playerId, r.playerHandle, r.run.tally))).toMap
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

      if (timeIsOver) stopGame()
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
      if (shouldSaveRun) {
        trackPoint(newState)
        if (prevState.crossedGates != newState.crossedGates) updateTally()
      }
    }

    /**
     * player quit => shutdown actor
     */
    case PlayerQuit(_) => {
      if (shouldSaveRun && !finished) TimeTrialRun.clean(run.id)
      self ! PoisonPill
    }

    /**
     * clean finished runs
     */
    case AutoClean => {
    }

  }

  def timeIsOver: Boolean = finishTime match {
    case Some(t) => run.creationTime.plus(t).plusSeconds(10).isBeforeNow
    case None => false
  }

  def stopGame() = {
    frameTick.cancel()
    gustsTick.cancel()
  }

  def updateTally() = {
    finishTime = if (finished) state.crossedGates.headOption else None
    TimeTrialRun.updateTimes(run.id, state.crossedGates, finishTime)
  }

  def trackPoint(state: PlayerState) = {
    val p = TrackPoint((clock % 1000).toInt, state.position, state.heading)
    if (currentSecond == activeSecond) {
      activePoints :+= p
    } else {
      val track = RunTrack(runId = run.id, second = activeSecond, points = activePoints)
      RunTrack.save(track).map { _ =>
        activeSecond = currentSecond
        activePoints = Seq(p)
      }
    }
  }

  def currentGhosts: Seq[GhostState] = {
    val second = clock / 1000
    val ms = (clock % 1000).toInt
    ghosts.map { case (GhostRun(gRun, tracks, playerId, playerHandle), ghostState) =>
      tracks.find(_.second == second).flatMap { track =>
        track.points.sortBy(p => math.abs(p.ms - ms)).headOption.map { p =>
          ghostState.copy(position = p.p, heading = p.h)
        }
      }.getOrElse(ghostState)
    }.toSeq
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
      watching = false,
      timeTrial = true
    )
  }

  override def postStop() = ticks.filterNot(_.isCancelled).foreach(_.cancel())
}

object TimeTrialActor {
  def props(timeTrial: TimeTrial, player: Player, run: TimeTrialRun) = Props(new TimeTrialActor(timeTrial, player, run))
}
