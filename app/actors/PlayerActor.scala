package actors

import akka.actor.{Props, Actor, ActorRef}
import org.joda.time.DateTime
import models._

import Frames._

class PlayerActor(player: Player, trackActor: ActorRef, out: ActorRef) extends Actor {

  trackActor ! PlayerJoin(player)

  def receive = {

    case PlayerInputFrame(input) =>
      trackActor ! PlayerUpdate(player, input)

    case NewMessageFrame(content) =>
      trackActor ! Message(player, content, DateTime.now)

    case raceUpdate: RaceUpdate =>
      out ! RaceUpdateFrame(raceUpdate)

    case message: Message =>
      out ! BroadcastMessageFrame(message)

  }

  override def postStop() = {
    trackActor ! PlayerQuit(player)
  }
}

object PlayerActor {
  def props(trackActor: ActorRef, player: Player)(out: ActorRef) = Props(new PlayerActor(player, trackActor, out))
}
