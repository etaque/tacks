package actors

import scala.concurrent.duration._
import scala.concurrent.ExecutionContext.Implicits.global
import akka.actor.{Props, Actor, ActorRef}
import akka.util.Timeout
import akka.pattern.{ ask, pipe }
import models.{PlayerInput, PlayerUpdate}

class PlayerActor(id: String, raceActor: ActorRef, out: ActorRef) extends Actor {

  def receive = {
    case pi: PlayerInput => {
      implicit val timeout = Timeout(1.second)
      (raceActor ? PlayerUpdate(id, pi)).map(out ! _)
    }
  }

  override def postStop() = {
    raceActor ! PlayerQuit(id)
  }
}

object PlayerActor {
  def props(raceActor: ActorRef, id: String)(out: ActorRef) = Props(new PlayerActor(id, raceActor, out))
}
