package actors

import scala.concurrent.duration._
import scala.concurrent.ExecutionContext.Implicits.global
import akka.actor.{Props, Actor, ActorRef}
import akka.util.Timeout
import akka.pattern.{ ask, pipe }
import models.{Player, PlayerInput, PlayerUpdate}

class PlayerActor(player: Player, raceActor: ActorRef, out: ActorRef) extends Actor {

  def receive = {
    case input: PlayerInput => {
      implicit val timeout = Timeout(1.second)
      (raceActor ? PlayerUpdate(player, input)).map { raceUpdate =>
        out ! raceUpdate
      }
    }
  }

  override def postStop() = {
    raceActor ! PlayerQuit(player.id.stringify)
  }
}

object PlayerActor {
  def props(raceActor: ActorRef, player: Player)(out: ActorRef) = Props(new PlayerActor(player, raceActor, out))
}
