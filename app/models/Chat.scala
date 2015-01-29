package models

import play.api.libs.json._
import JsonFormats.playerFormat

object Chat {

  sealed trait Action
  case object NoOp extends Action
  case class SetPlayer(p: Player) extends Action
  case class UpdatePlayers(players: Seq[Player]) extends Action
  case class NewMessage(p: Player, content: String) extends Action
  case class NewStatus(u: User, content: String) extends Action
  case class SubmitMessage(content: String) extends Action
  case class SubmitStatus(content: String) extends Action

  implicit val actionFormat: Format[Action] = new Format[Action] {

    def tag(t: String) = Json.obj("tag" -> JsString(t))
    def player(p: Player) = Json.obj("player" -> playerFormat.writes(p))

    override def writes(o: Action): JsValue = o match {
      case SetPlayer(p) => tag("SetPlayer") ++ player(p)
      case UpdatePlayers(players) => tag("UpdatePlayers") ++ Json.obj("players" -> JsArray(players.map(playerFormat.writes)))
      case NewMessage(p, c) => tag("NewMessage") ++ player(p) ++ Json.obj("content" -> JsString(c))
      case _ => tag("NoOp")
    }

    override def reads(json: JsValue): JsResult[Action] = json \ "tag" match {

      case JsString("SubmitMessage") => json \ "content" match {
        case JsString(content) => JsSuccess(SubmitMessage(content))
        case _ => JsSuccess(NoOp)
      }

      case JsString("SubmitStatus") => json \ "content" match {
        case JsString(content) => JsSuccess(SubmitStatus(content))
        case _ => JsSuccess(NoOp)
      }

      case _ => JsSuccess(NoOp)
    }

  }
}
