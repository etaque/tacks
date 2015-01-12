package actors

import akka.actor.{Props, ActorRef, Actor}
import models.Player

case class NotificationEvent(key: String, params: Seq[String])
case class Subscribe(player: Player, ref: ActorRef)
case class Unsubscribe(player: Player, ref: ActorRef)

class NotifiableActor(player: Player, out: ActorRef) extends Actor {

  RacesSupervisor.actorRef ! Subscribe(player, self)

  def receive = {
    case e: NotificationEvent => out forward e
  }

  override def postStop() = {
    RacesSupervisor.actorRef ! Unsubscribe(player, self)
  }
}

object NotifiableActor {
  def props(player: Player)(out: ActorRef) = Props(new NotifiableActor(player, out))
}
