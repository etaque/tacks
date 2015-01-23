package actors

import akka.actor.{Props, ActorRef, Actor}
import models.Player

class ChatPlayerActor(player: Player, out: ActorRef) extends Actor {

  def receive = {
    case m: ChatMessage => {
      if (sender == out) ChatRoom.actorRef ! m
      else out ! m
    }
  }

}

object ChatPlayerActor {
  def props(player: Player)(out: ActorRef) = Props(new ChatPlayerActor(player, out))
}
