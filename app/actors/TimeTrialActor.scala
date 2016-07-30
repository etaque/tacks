package actors

import akka.util.Timeout
import java.util.UUID
import play.api.Logger
import scala.concurrent.duration._
import scala.concurrent.Future
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import akka.actor._
import akka.pattern._
import org.joda.time.DateTime

import models._
import dao._
import tools.Conf


class TimeTrialActor(timeTrial: TimeTrial, track: Track) extends Actor with ManageWind {

  var state = TrackState(
    track = track,
    races = Seq.empty, // useless here
    players = Map.empty, // useless too
    paths = Map.empty,
    playersGhosts = Map.empty,
    ghostRuns = Map.empty
  )

  def clock: Long =
    DateTime.now.getMillis - timeTrial.creationTime.getMillis

  def course = track.course
  def creationTime = timeTrial.creationTime

  val ticks = Seq(
    Akka.system.scheduler.schedule(0.seconds, course.gustGenerator.interval.seconds, self, TrackAction.SpawnGust),
    Akka.system.scheduler.schedule(0.seconds, Conf.frameMillis.milliseconds, self, TrackAction.FrameTick)
  )

  def receive = {

    case PlayerAction(_, action) =>
      import PlayerAction._
      action match {

        case Input(PlayerInput(opState, clientTime)) =>

        case AddGhost(runId) =>

        case RemoveGhost(runId) =>

        case _ =>
          // ignore for time trials
      }

    case trackAction: TrackAction.Action =>
      import TrackAction._

      trackAction match {

        case FrameTick =>
          updateWind()

        case SaveRun(race, ctx, maybePath) =>
          val lastKnownPath = state.paths.lift(ctx.player.id).orElse(maybePath)
          TrackActor.saveRun(track, Some(timeTrial), race, ctx, lastKnownPath)

        case InitGhost(player, run, path) =>
          state = state.addGhost(player, run, path)

        case SpawnGust =>
          generateGust()

        case _ =>
          // ignore
      }
  }

  override def postStop() = {
    ticks.foreach(_.cancel())
  }
}

object TimeTrialActor {
  def props(timeTrial: TimeTrial, track: Track) =
    Props(new TimeTrialActor(timeTrial, track))
}
