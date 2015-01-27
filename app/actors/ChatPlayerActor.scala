package actors

import akka.actor.{Props, ActorRef, Actor}
import models.{Chat, Player}

class ChatPlayerActor(player: Player, out: ActorRef) extends Actor {

  val room = ChatRoom.actorRef

  room ! PlayerJoin(player)

  def receive = {
    case a: Chat.Action => {
      out ! a
    }

    case Chat.SubmitMessage(content) => {
      val msg = Chat.NewMessage(player, content)
      room ! msg
    }
  }

  override def postStop() = {
    room ! PlayerQuit(player)
  }

}

object ChatPlayerActor {
  def props(player: Player)(out: ActorRef) = Props(new ChatPlayerActor(player, out))
}
