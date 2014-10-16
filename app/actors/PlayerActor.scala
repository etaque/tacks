package actors

import core.steps._
import org.joda.time.DateTime

import akka.actor.{Props, Actor, ActorRef}
import models._

case class RunStep(
  previousState: PlayerState,
  input: PlayerInput,
  now: DateTime,
  wind: Wind,
  race: Race,
  started: Boolean,
  opponents: Seq[PlayerState]
)

case class StepResult(prevState: PlayerState, newState: PlayerState)

class PlayerActor(player: Player, raceActor: ActorRef, out: ActorRef) extends Actor {

  def receive = {

    case input: PlayerInput => raceActor ! PlayerUpdate(player, input)

    case RunStep(previousState, input, now, wind, race, started, opponents) => {
      val elapsed = now.getMillis - previousState.time.getMillis

      val runner = if (elapsed > 0) {
        BoatTurningStep.run(previousState, input, elapsed) _ andThen
          WindStep.run(wind, race.course.windShadowLength, opponents) andThen
          VmgStep.run andThen
          BoatMovingStep.run(elapsed, race.course) andThen
          GateCrossingStep.run(previousState, race.course, started)
      } else {
        identity[PlayerState] _
      }

      val newState = runner(previousState).copy(time = now)
      sender ! StepResult(previousState, newState)
    }

    case raceUpdate: RaceUpdate => out ! raceUpdate

  }

  override def postStop() = {
    raceActor ! PlayerQuit(player.id.stringify)
  }
}

object PlayerActor {
  def props(raceActor: ActorRef, player: Player)(out: ActorRef) = Props(new PlayerActor(player, raceActor, out))
}
