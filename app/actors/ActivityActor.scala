package actors

import akka.actor.{Props, ActorRef, Actor}
import play.api.libs.json._
import models._

case class ActivityMsg(player: Player, ref: ActorRef, msg: ActivityMsg.Msg)

object ActivityMsg {
  sealed trait Msg

  case object Ping extends Msg

  implicit val msgFormat: Format[Msg] = new Format[Msg] {

    override def writes(a: Msg): JsValue =
      Json.obj()

    override def reads(json: JsValue): JsResult[Msg] = json \ "tag" match {
      case JsDefined(JsString(s)) => s match {

        // case "Ping" =>
        //   (json \ "playerInput").validate[PlayerInput].map(Input(_))

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

class ActivityActor(player: Player, out: ActorRef) extends Actor {
  import ActivityMsg._

  def receive = {
    case Ping =>
      LiveCenter.actorRef ! ActivityMsg(player, out, Ping)

    // case e: NotificationEvent =>
    //   out forward e
  }

  override def postStop() = {
  }
}

object ActivityActor {
  def props(player: Player)(out: ActorRef) = Props(new ActivityActor(player, out))
}
