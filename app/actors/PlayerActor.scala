package actors

import org.joda.time.DateTime

import scala.concurrent.duration._
import scala.concurrent.ExecutionContext.Implicits.global
import akka.actor.{Props, Actor, ActorRef}
import akka.util.Timeout
import akka.pattern.{ ask, pipe }
import models.{User, PlayerInput, PlayerUpdate}

class PlayerActor(user: User, raceActor: ActorRef, out: ActorRef) extends Actor {

  var lastUpdate = DateTime.now

  def receive = {
    case input: PlayerInput => {
      implicit val timeout = Timeout(1.second)
      val now = DateTime.now
      val delta = now.getMillis - lastUpdate.getMillis
      (raceActor ? PlayerUpdate(user, input, delta)).map { raceUpdate =>
        lastUpdate = now
        out ! raceUpdate
      }
    }
  }

  override def postStop() = {
    raceActor ! PlayerQuit(user.id.stringify)
  }
}

object PlayerActor {
  def props(raceActor: ActorRef, user: User)(out: ActorRef) = Props(new PlayerActor(user, raceActor, out))
}
