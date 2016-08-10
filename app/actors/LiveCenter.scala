package actors

import play.api.Logger
import scala.concurrent.Future

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


case class LiveCenterState(
  onlinePlayers: Map[PlayerId, (Player, ActorRef, DateTime)] = Map.empty,
  chatRoom: Seq[(Player, ActorRef)] = Nil
) {
  def ping(player: Player, ref: ActorRef, time: DateTime): LiveCenterState = {
    copy(
      onlinePlayers = onlinePlayers + (player.id -> (player, ref, time))
    )
  }

  def removeStale(time: DateTime): LiveCenterState = {
    copy(
      onlinePlayers = onlinePlayers.filter(_._2._3.isAfter(time))
    )
  }

  def listOnlinePlayers = {
    onlinePlayers.values.toSeq.map(_._1)
  }
}

case object GetOnlinePlayers
case object Refresh
case class BroadcastLiveStatus(liveStatus: LiveStatus)

class LiveCenter extends Actor {

  var state = LiveCenterState()
  // implicit val timeout = Timeout(1.seconds)

  Akka.system.scheduler.schedule(1.second, 1.second, self, Refresh)

  def receive = {

    case ActivityMsg(player, ref, msg) =>
      import Emit._

      msg match {
        case Ping =>
          state = state.ping(player, ref, DateTime.now)

        case Poke(playerId) =>
          state.onlinePlayers.get(playerId).foreach {
            case (_, ref, _) =>
              ref ! Receive.PokedBy(player)
          }
      }

    case Refresh =>
      state = state.removeStale(DateTime.now.minusSeconds(5))
      val broadcastFu = for {
        liveTracks <- LiveStatus.getLiveTracks()
        liveTimeTrial <- LiveStatus.getLiveTimeTrial()
      } yield BroadcastLiveStatus(LiveStatus(liveTracks, liveTimeTrial, state.listOnlinePlayers))
      broadcastFu.pipeTo(self)

    case BroadcastLiveStatus(liveStatus) =>
      state.onlinePlayers.values.foreach { case (_, ref, _) =>
        ref ! Receive.RefreshLiveStatus(liveStatus)
      }

    case GetOnlinePlayers =>
      sender ! state.listOnlinePlayers
  }
}

object LiveCenter {
  val actorRef = Akka.system.actorOf(Props[LiveCenter])

  implicit val timeout = Timeout(1.seconds)

  def sendPlayersUpdate(state: LiveCenterState) = {
    val distinctPlayers = (state.listOnlinePlayers ++ state.chatRoom.map(_._1)).distinct.sortBy(_.handleOpt)
  }
}
