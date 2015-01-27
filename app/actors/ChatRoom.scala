package actors

import akka.actor.{ActorRef, Props, Actor}
import models.{Chat, Player}
import play.api.libs.concurrent.Akka
import play.api.Play.current

case object GetOnlinePlayers

class ChatRoom extends Actor {
  
  var players = Seq.empty[(Player, ActorRef)]

  def receive = {

    case PlayerJoin(player) => {
      players = players :+ (player, sender)
      updatePlayers()
    }

    case PlayerQuit(player) => {
      players = players.filterNot(_._2 == sender)
      updatePlayers()
    }

    case m: Chat.NewMessage => {
      players.foreach(_._2 ! m)
    }
    
    case GetOnlinePlayers => sender ! players.map(_._1)

  }

  def updatePlayers() = {
    val distinctPlayers = players.map(_._1).distinct.sortBy(_.handleOpt)
    players.foreach(_._2 ! Chat.UpdatePlayers(distinctPlayers))
  }

}

object ChatRoom {
  val actorRef = Akka.system.actorOf(Props[ChatRoom])
}
