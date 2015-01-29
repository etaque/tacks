package actors

import akka.actor.{Props, ActorRef, Actor}
import models.Player

class NotifiableActor(player: Player, out: ActorRef) extends Actor {

  LiveCenter.actorRef ! Subscribe(player, self)

  def receive = {
    case e: NotificationEvent => out forward e
  }

  override def postStop() = {
    LiveCenter.actorRef ! Unsubscribe(player, self)
  }
}

object NotifiableActor {
  def props(player: Player)(out: ActorRef) = Props(new NotifiableActor(player, out))
}
