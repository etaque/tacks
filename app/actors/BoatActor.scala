package actors

import scala.concurrent.duration._
import scala.concurrent.ExecutionContext.Implicits.global
import akka.actor.{Props, Actor, ActorRef}
import akka.util.Timeout
import akka.pattern.{ ask, pipe }
import models.{BoatState, BoatUpdate}

class BoatActor(id: String, raceActor: ActorRef, out: ActorRef) extends Actor {

  def receive = {
    case bs: BoatState => {
      implicit val timeout = Timeout(1.second)
      (raceActor ? BoatUpdate(id, bs)).map(out ! _)
    }
  }

  override def postStop() = {
    raceActor ! BoatLeaved(id)
  }
}

object BoatActor {
  def props(raceActor: ActorRef, id: String)(out: ActorRef) = Props(new BoatActor(id, raceActor, out))
}