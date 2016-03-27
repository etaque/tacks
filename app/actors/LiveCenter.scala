package actors

import play.api.Logger

import scala.concurrent.duration._
import akka.actor.{ActorRef, Props, Actor}
import akka.pattern.{ask,pipe}
import akka.util.Timeout
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import play.api.Play.current
import org.joda.time.DateTime

import models._
import dao._


case class Subscribe(player: Player, ref: ActorRef)
case class Unsubscribe(player: Player, ref: ActorRef)
case object GetOnlinePlayers
case class NotificationEvent(key: String, params: Seq[String])

case class LiveCenterState(
  subscribers: Seq[(Player, ActorRef)] = Nil,
  chatRoom: Seq[(Player, ActorRef)] = Nil
)

class LiveCenter extends Actor {

  var state = LiveCenterState()
  implicit val timeout = Timeout(1.seconds)

  def receive = {

    // case Subscribe(player, ref) => {
    //   state = state.copy(subscribers = state.subscribers :+ (player, ref))
    //   Logger.debug("Player ref subscribed to notifications: " + player.toString)
    //   LiveCenter.sendPlayersUpdate(state)
    // }

    // case Unsubscribe(player, ref) => {
    //   state = state.copy(subscribers = state.subscribers.filterNot(_._2 == ref))
    //   Logger.debug("Player ref unsubscribed from notifications: " + player.toString)
    //   LiveCenter.sendPlayersUpdate(state)
    // }

    // case PlayerJoin(player) => {
    //   state = state.copy(chatRoom = state.chatRoom :+ (player, sender))
    //   Logger.debug("Player ref joined chat room: " + player.toString)
    //   LiveCenter.sendPlayersUpdate(state)
    // }

    // case PlayerQuit(player) => {
    //   state = state.copy(chatRoom = state.chatRoom.filterNot(_._2 == sender))
    //   Logger.debug("Player ref left chat room: " + player.toString)
    //   LiveCenter.sendPlayersUpdate(state)
    // }

    // case m: Chat.NewMessage => {
    //   state.chatRoom.foreach(_._2 ! m)
    //   Logger.debug("Player sent new message: " + m.toString)
    // }

    // case Chat.NewStatus(user, content) => {
    //   state = LiveCenter.updateStatus(state, user.id, content)
    //   Logger.debug("Player submitted new status: " + user.toString)
    //   LiveCenter.sendPlayersUpdate(state)
    //   UserDAO.updateStatus(user.id, Some(content))
    // }

    case GetOnlinePlayers => sender ! state.subscribers.map(_._1).distinct

  }

}

object LiveCenter {
  val actorRef = Akka.system.actorOf(Props[LiveCenter])

  implicit val timeout = Timeout(1.seconds)

  def sendPlayersUpdate(state: LiveCenterState) = {
    val distinctPlayers = (state.subscribers.map(_._1) ++ state.chatRoom.map(_._1)).distinct.sortBy(_.handleOpt)
    // Logger.debug(s"Sending players update to ${state.chatRoom.size} refs: " + distinctPlayers.toString)
    // state.chatRoom.foreach(_._2 ! Chat.UpdatePlayers(distinctPlayers))
  }

  // def updateStatus(state: LiveCenterState, playerId: BSONObjectID, status: String): LiveCenterState = {
  //   state.copy(
  //     subscribers = state.subscribers.map(updatePlayerStatus(playerId, status)),
  //     chatRoom = state.chatRoom.map(updatePlayerStatus(playerId, status))
  //   )
  // }

  // def updatePlayerStatus(id: BSONObjectID, status: String)(pair: (Player, ActorRef)): (Player, ActorRef) = {
  //   val (p, ref) = pair
  //   p match {
  //     case u: User if u.id == id => (u.copy(status = Some(status)), ref)
  //     case _ => (p, ref)
  //   }
  // }
}
