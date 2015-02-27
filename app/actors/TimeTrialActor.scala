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

case class RunState(
  trial: TimeTrial,
  run: TimeTrialRun,
  state: OpponentState,
  activeSecond: Long,
  activePoints: Seq[TrackPoint],
  ghosts: Map[GhostRun, GhostState]
) {
  def finished = state.crossedGates.length == trial.course.gatesToCross

  def finishTime = if (finished) state.crossedGates.headOption else None

  def timeIsOver: Boolean = finishTime match {
    case Some(t) => run.creationTime.plus(t).plusSeconds(10).isBeforeNow
    case None => false
  }

  def ghostsAt(clock: Long): Seq[GhostState] = {
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

  def withGhostRuns(ghostRuns: Seq[GhostRun]): RunState = {
    copy(
      ghosts = ghostRuns.map(r => (r, GhostState.initial(r.playerId, r.playerHandle, r.run.tally))).toMap
    )
  }
}

class TimeTrialActor(trial: TimeTrial, player: Player, run: TimeTrialRun) extends Actor with ManageWind {

  val id = trial.id
  val course = trial.course

  var playerRef: Option[ActorRef] = None

  val startTime = run.time.plusSeconds(trial.countdownSeconds)
  def clock = DateTime.now.getMillis - startTime.getMillis + trial.countdownSeconds * 1000

  var runState = RunState(
    trial = trial,
    run = run,
    state = OpponentState.initial,
    activeSecond = clock / 1000,
    activePoints = Nil,
    ghosts = Map.empty
  )

  val cleanTick = Akka.system.scheduler.schedule(10.seconds, 10.seconds, self, AutoClean)

  def shouldSaveRun = player match {
    case u: User => true
    case g: Guest => g.handle.isDefined
  }

  if (shouldSaveRun) TimeTrialRun.save(run)

  def receive = {

    /**
     * player join => keep actor ref
     */
    case PlayerJoin(_) => {
      playerRef = Some(sender())
    }

    case SetGhostRuns(runs) => {
      runState = runState.withGhostRuns(runs)
    }

    /**
     * player update coming from websocket through player actor
     * send a race update to player actor for websocket transmission
     */
    case PlayerUpdate(_, PlayerInput(newState, _, clientTime)) => {
      val prevState = runState.state
      runState = runState.copy(state = newState)

      playerRef.foreach { ref =>
        ref ! raceUpdate(clientTime)
      }

      if (shouldSaveRun) {
        runState = TimeTrialActor.trackPoint(runState, clock)
        if (prevState.crossedGates != newState.crossedGates) TimeTrialActor.updateTally(runState)
      }
    }

    /**
     * player quit => shutdown actor
     */
    case PlayerQuit(_) => {
      cleanStop()
    }

    /**
     * clean finished runs
     */
    case AutoClean => {
      if (runState.timeIsOver) cleanStop()
    }

  }

  def cleanStop() = {
    if (shouldSaveRun && !runState.finished) TimeTrialRun.clean(run.id)
    self ! PoisonPill
  }

  def raceUpdate(clientTime: Long) = {
    RaceUpdate(
      serverNow = DateTime.now,
      startTime = Some(startTime),
      wind = wind,
      opponents = Nil,
      ghosts = runState.ghostsAt(clock),
      leaderboard = Nil,
      isMaster = true,
      clientTime = clientTime
    )
  }

  override def postStop() = cleanTick.cancel()
}

object TimeTrialActor {
  def props(timeTrial: TimeTrial, player: Player, run: TimeTrialRun) = Props(new TimeTrialActor(timeTrial, player, run))

  def updateTally(runState: RunState): Unit = {
    TimeTrialRun.updateTimes(runState.run.id, runState.state.crossedGates, runState.finishTime)
  }

  def trackPoint(runState: RunState, clock: Long): RunState = {
    val currentSecond = clock / 1000
    val p = TrackPoint((clock % 1000).toInt, runState.state.position, runState.state.heading)
    if (currentSecond == runState.activeSecond) {
      runState.copy(
        activePoints = runState.activePoints :+ p
      )
    } else {
      val track = RunTrack(runId = runState.run.id, second = runState.activeSecond, points = runState.activePoints)
      RunTrack.save(track)
      runState.copy(
        activeSecond = currentSecond,
        activePoints = Seq(p)
      )
    }
  }
}
