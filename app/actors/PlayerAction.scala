package actors

import java.util.UUID
import play.api.libs.json._
import models._
import models.JsonFormats._


case class PlayerAction(player: Player, action: PlayerAction.Action)

object PlayerAction {
  sealed trait Action

  case object NoOp extends Action
  case object Join extends Action
  case class Input(input: PlayerInput) extends Action
  case object Quit extends Action
  case object StartRace extends Action
  case object ExitRace extends Action
  case class NewMessage(content: String) extends Action
  case class AddGhost(runId: UUID) extends Action
  case class RemoveGhost(runId: UUID) extends Action


  implicit val actionFormat: Format[Action] = new Format[Action] {

    override def writes(a: Action): JsValue =
      Json.obj()

    override def reads(json: JsValue): JsResult[Action] = json \ "tag" match {
      case JsDefined(JsString(s)) => s match {

        case "PlayerInput" =>
          (json \ "playerInput").validate[PlayerInput].map(Input(_))

        case "SendMessage" =>
          (json \ "content").validate[String].map(NewMessage(_))

        case "AddGhost" =>
          (json \ "runId").validate[UUID].map(AddGhost(_))

        case "RemoveGhost" =>
          (json \ "runId").validate[UUID].map(RemoveGhost(_))

        case "StartRace" =>
          JsSuccess(StartRace)

        case "EscapeRace" =>
          JsSuccess(ExitRace)

        case "ServerNoOp" =>
          JsSuccess(NoOp)

        case _ =>
          JsError("Unkown PlayerAction tag: " + json)
      }

      case _ =>
        JsError("Unkown PlayerAction tag: " + json)
    }
  }

}

