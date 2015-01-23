package actors


import reactivemongo.bson.BSONObjectID

import scala.concurrent.duration._
import akka.actor.{ActorRef, Props, Actor}
import akka.pattern.{ask,pipe}
import models.{Player}
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import play.api.Play.current

case class Ping(player: Player)
case object GetOnlinePlayers
case object RemoveInactivePlayers
case class NewMessage(m: ChatMessage)

case class ChatMessage(playerId: BSONObjectID, playerHandle: String, content: String)

class ChatRoom extends Actor {
  
//  var onlinePlayers = Seq[(Player, DateTime)]()

  var players = Seq.empty[(Player, ActorRef)]

  Akka.system.scheduler.schedule(0.second, 1.second, self, RemoveInactivePlayers)
  
  def receive = {

    case PlayerJoin(player) => {
      players = players :+ (player, sender)
    }

    case PlayerQuit(player) => {
      players = players.filterNot(_._2 == sender)
    }

    case NewMessage(m) => {
      players.foreach(_._2 ! m)
    }
    
////    case Ping(player) => {
////      onlinePlayers = (player, DateTime.now) +: onlinePlayers.filterNot(_._1.id == player.id)
////    }
//
//    case GetOnlinePlayers => sender ! onlinePlayers.map(_._1)

//    case RemoveInactivePlayers => {
//      onlinePlayers = onlinePlayers.filterNot(_._2.plusMinutes(1).isBeforeNow)
//    }
  }

}

object ChatRoom {
  val actorRef = Akka.system.actorOf(Props[ChatRoom])
}
