package actors

import akka.actor.{Props, Actor, ActorRef}
import org.joda.time.DateTime
import models._


class PlayerActor(player: Player, trackActor: ActorRef, out: ActorRef) extends Actor {

  trackActor ! PlayerAction(player, PlayerAction.Join)

  def receive = {
    case action: PlayerAction.Action =>
      trackActor ! PlayerAction(player, action)

    case raceUpdate: RaceUpdate =>
      out ! ServerAction.PushRaceUpdate(raceUpdate)

    case message: Message =>
      out ! ServerAction.BroadcastMessage(message)

    case liveTrack: LiveTrack =>
      out ! ServerAction.BroadcastLiveTrack(liveTrack)
  }

  override def postStop() = {
    trackActor ! PlayerAction(player, PlayerAction.Quit)
  }
}

object PlayerActor {
  def props(trackActor: ActorRef, player: Player)(out: ActorRef) = Props(new PlayerActor(player, trackActor, out))
}
