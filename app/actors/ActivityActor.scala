package actors

import akka.actor.{Props, ActorRef, Actor}
import play.api.libs.json._
import models._
import JsonFormats.playerFormat


case class ActivityMsg(
  player: Player,
  ref: ActorRef,
  msg: Emit.Msg
)

object Emit {
  sealed trait Msg

  case object Ping extends Msg
  case class Poke(playerId: PlayerId) extends Msg

  implicit val msgFormat: Format[Msg] = new Format[Msg] {

    override def writes(a: Msg): JsValue =
      Json.obj()

    override def reads(json: JsValue): JsResult[Msg] = json \ "tag" match {
      case JsDefined(JsString(s)) => s match {

        case "Poke" =>
          (json \ "playerId").validate[PlayerId].map(Poke(_))

        case "Ping" =>
          JsSuccess(Ping)

        case _ =>
          JsError("Unkown ActivityMsg tag: " + json)
      }

      case _ =>
        JsError("Unkown ActivityMsg tag: " + json)
    }
  }
}

object Receive {
  sealed trait Msg

  case class PokedBy(player: Player) extends Msg

  implicit val msgFormat: Format[Msg] = new Format[Msg] {
    override def writes(msg: Msg): JsValue =
      msg match {
        case PokedBy(player) =>
          Json.obj("tag" -> "PokedBy", "player" -> Json.toJson(player))
      }
    override def reads(json: JsValue): JsResult[Msg] =
      JsError("Not implemented")
  }
}

class ActivityActor(player: Player, out: ActorRef) extends Actor {

  def receive = {
    case msg: Emit.Msg =>
      LiveCenter.actorRef ! ActivityMsg(player, out, msg)

    case msg: Receive.Msg =>
      out ! msg
  }

  override def postStop() = {
  }
}

object ActivityActor {
  def props(player: Player)(out: ActorRef) = Props(new ActivityActor(player, out))
}
