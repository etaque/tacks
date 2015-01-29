package actors

import akka.actor.{Props, ActorRef, Actor}
import models.{Guest, User, Chat, Player}

class ChatPlayerActor(player: Player, out: ActorRef) extends Actor {

  val liveCenter = LiveCenter.actorRef

  liveCenter ! PlayerJoin(player)
  out ! Chat.SetPlayer(player)

  def receive = {

    case Chat.SubmitMessage(content) => {
      val msg = Chat.NewMessage(player, content)
      liveCenter ! msg
    }

    case Chat.SubmitStatus(content) => {
      player match {
        case u: User => liveCenter ! Chat.NewStatus(u, content)
        case g: Guest => // nope
      }
    }

    case a: Chat.Action => {
      out ! a
    }

  }

  override def postStop() = {
    liveCenter ! PlayerQuit(player)
  }

}

object ChatPlayerActor {
  def props(player: Player)(out: ActorRef) = Props(new ChatPlayerActor(player, out))
}
