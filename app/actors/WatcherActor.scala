package actors

import akka.actor.{Props, ActorRef, Actor}
import models.{Player, WatcherUpdate, WatcherInput, RaceUpdate}

class WatcherActor(watcher: Player, raceActor: ActorRef, out: ActorRef) extends Actor {

  raceActor ! WatcherJoin(watcher)

  def receive = {

    case input: WatcherInput =>
      raceActor ! WatcherUpdate(watcher, input)

    case update: RaceUpdate =>
      out ! update

  }

  override def postStop() = WatcherQuit(watcher)
}

object WatcherActor {
  def props(raceActor: ActorRef, watcher: Player)(out: ActorRef) = Props(new WatcherActor(watcher, raceActor, out))
}
