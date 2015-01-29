package actors

import reactivemongo.bson.BSONObjectID

import scala.concurrent.duration._
import akka.actor.{ActorRef, Props, Actor}
import akka.pattern.{ask,pipe}
import akka.util.Timeout
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import play.api.Play.current
import org.joda.time.DateTime
import models._

case class Subscribe(player: Player, ref: ActorRef)
case class Unsubscribe(player: Player, ref: ActorRef)
case class NotifyNewRace(raceActor: ActorRef, race: Race, master: User)
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

    case Subscribe(player, ref) => {
      state = state.copy(subscribers = state.subscribers :+ (player, ref))
      LiveCenter.sendPlayersUpdate(state)
    }

    case Unsubscribe(player, ref) => {
      state = state.copy(subscribers = state.subscribers.filterNot(_._2 == ref))
      LiveCenter.sendPlayersUpdate(state)
    }

    case PlayerJoin(player) => {
      state = state.copy(chatRoom = state.chatRoom :+ (player, sender))
      LiveCenter.sendPlayersUpdate(state)
    }

    case PlayerQuit(player) => {
      state = state.copy(chatRoom = state.chatRoom.filterNot(_._2 == sender))
      LiveCenter.sendPlayersUpdate(state)
    }

    case m: Chat.NewMessage => {
      state.chatRoom.foreach(_._2 ! m)
    }

    case Chat.NewStatus(user, content) => {
      state = LiveCenter.updateStatus(state, user.id, content)
      LiveCenter.sendPlayersUpdate(state)
      User.updateStatus(user.id, Some(content))
    }
    
    case GetOnlinePlayers => sender ! state.subscribers.map(_._1).distinct

    case NotifyNewRace(ref, race, master) => {
      LiveCenter.notifyNewRace(state, ref, race, master)
    }

  }

}

object LiveCenter {
  val actorRef = Akka.system.actorOf(Props[LiveCenter])

  implicit val timeout = Timeout(1.seconds)

  def sendPlayersUpdate(state: LiveCenterState) = {
    val distinctPlayers = state.subscribers.map(_._1).distinct.sortBy(_.handleOpt)
    state.chatRoom.foreach(_._2 ! Chat.UpdatePlayers(distinctPlayers))
  }

  def notifyNewRace(state: LiveCenterState, raceActor: ActorRef, race: Race, master: User) = {
    (raceActor ? GetStatus).mapTo[(Option[DateTime], Seq[PlayerState])].map { case (startTime, playerStates) =>
      state.subscribers.collect {
        // notify only users, excluding master & those who already joined
        case (u: User, ref: ActorRef) if u.id != master.id && !playerStates.map(_.player.id).contains(u.id) => (u, ref)
      }.foreach { case (_, ref) =>
        ref ! NotificationEvent("newRace", Seq(race.generator, master.handle))
      }
    }
  }

  def updateStatus(state: LiveCenterState, playerId: BSONObjectID, status: String): LiveCenterState = {
    state.copy(
      subscribers = state.subscribers.map(updatePlayerStatus(playerId, status)),
      chatRoom = state.chatRoom.map(updatePlayerStatus(playerId, status))
    )
  }

  def updatePlayerStatus(id: BSONObjectID, status: String)(pair: (Player, ActorRef)): (Player, ActorRef) = {
    val (p, ref) = pair
    p match {
      case u: User if u.id == id => (u.copy(status = Some(status)), ref)
      case _ => (p, ref)
    }
  }
}
