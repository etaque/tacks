package actors

//import core.steps._

import akka.actor.{Props, Actor, ActorRef}
import models._

//case class RunStep(
//  previousState: PlayerState,
//  input: KeyboardInput,
//  now: Long,
//  wind: Wind,
//  course: Course,
//  started: Boolean,
//  opponents: Seq[PlayerState]
//)

case class StepResult(prevState: PlayerState, newState: PlayerState)

class PlayerActor(player: Player, raceActor: ActorRef, out: ActorRef) extends Actor {

  raceActor ! PlayerJoin(player)

  def receive = {

    case input: PlayerInput => raceActor ! PlayerUpdate(player, input)

    case input: TutorialInput => raceActor forward input

//    case RunStep(previousState, input, now, wind, course, started, opponents) => {
//      val elapsed = now - previousState.time
//
//      val runner = if (elapsed > 0) {
//        BoatTurningStep.run(previousState, input, elapsed) _ andThen
//          WindStep.run(wind, course.windShadowLength, opponents) andThen
//          VmgStep.run andThen
//          BoatMovingStep.run(elapsed, course) andThen
//          GateCrossingStep.run(previousState, course, started, now)
//      } else {
//        identity[PlayerState] _
//      }
//
//      val newState = runner(previousState).copy(time = now)
//      sender ! StepResult(previousState, newState)
//    }

    case raceUpdate: RaceUpdate => out ! raceUpdate

    case tutUpdate: TutorialUpdate => out ! tutUpdate
  }

  override def postStop() = {
    raceActor ! PlayerQuit(player)
  }
}

object PlayerActor {
  def props(raceActor: ActorRef, player: Player)(out: ActorRef) = Props(new PlayerActor(player, raceActor, out))
}
