package actors

import scala.concurrent.duration._
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import akka.actor.{Props, PoisonPill, ActorRef, Actor}
import org.joda.time.DateTime

import tools.Conf
import models._

class TutorialActor(player: Player) extends Actor with ManageWind {

  var playerRef: Option[ActorRef] = None

  var step = TutorialStep.initial

  var playerState = PlayerState.initial(player)
  var input = PlayerInput.initial

  val course = Course.forTutorial
  val id = player.id

  def clock: Long = DateTime.now.getMillis

  val frameTick = Akka.system.scheduler.schedule(0.seconds, Conf.frameMillis.milliseconds, self, FrameTick)
  var ticks = Seq(frameTick)

  def receive = {

    /**
     * player join => keep actor ref
     */
    case PlayerJoin(_) => {
      playerRef = Some(sender())
    }

    /**
     * game heartbeat:
     *  - update wind (origin, speed and gusts positions)
     *  - send a race update to player actor for websocket transmission
     *  - tell player actor to run step
     */
    case FrameTick => {
      playerRef.foreach { ref =>
        ref ! update
        ref ! RunStep(playerState, input, clock, wind, course, started = true, Nil)
      }
    }

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
      playerState = newState
    }

    /**
     * player quit => shutdown actor
     */
    case PlayerQuit(_) => {
      self ! PoisonPill
    }
  }

  def update = {
    TutorialUpdate(
      clock,
      playerState = playerState,
      course = None,
      step = step
    )
  }

  override def postStop() = ticks.filterNot(_.isCancelled).foreach(_.cancel())
}

object TutorialActor {
  def props(player: Player) = Props(new TutorialActor(player))
}
