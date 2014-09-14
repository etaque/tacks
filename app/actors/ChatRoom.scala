package actors

import org.joda.time.DateTime

import scala.concurrent.duration._
import akka.actor.{Props, Actor}
import models.{Player, User}
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import play.api.Play.current

case class Ping(player: Player)
case object GetOnlinePlayers
case object RemoveInactivePlayers

class ChatRoom extends Actor {
  
  var onlinePlayers = Seq[(Player, DateTime)]()

  Akka.system.scheduler.schedule(0.second, 1.second, self, RemoveInactivePlayers)
  
  def receive = {
    
    case Ping(player) => {
      onlinePlayers = (player, DateTime.now) +: onlinePlayers.filterNot(_._1.id == player.id)
    }
      
    case GetOnlinePlayers => sender ! onlinePlayers.map(_._1)

    case RemoveInactivePlayers => {
      onlinePlayers = onlinePlayers.filterNot(_._2.plusMinutes(1).isBeforeNow)
    }
  }

}

object ChatRoom {
  val actorRef = Akka.system.actorOf(Props[ChatRoom])
}
