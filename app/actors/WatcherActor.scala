package actors

import akka.actor.{Props, ActorRef, Actor}
import models.{WatcherInput, RaceUpdate}

class WatcherActor(raceActor: ActorRef, out: ActorRef) extends Actor {

  raceActor ! WatcherJoin

  def receive = {

    case watcherInput: WatcherInput => // ignore, useless atm

    case raceUpdate: RaceUpdate => out ! raceUpdate

  }

  override def postStop() = {
    raceActor ! WatcherQuit
  }
}

object WatcherActor {
  def props(raceActor: ActorRef)(out: ActorRef) = Props(new WatcherActor(raceActor, out))
}
