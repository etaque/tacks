package models

import play.api.libs.json._
import JsonFormats.playerFormat

object Chat {

  case class SubmitMessage(content: String)

  implicit val submitMessageFormat: Format[SubmitMessage] = Json.format[SubmitMessage]

  sealed trait Action
  case object NoOp extends Action
  case class SetPlayer(p: Player) extends Action
  case class UpdatePlayers(players: Seq[Player]) extends Action
  case class NewMessage(p: Player, content: String) extends Action

  implicit val actionFormat: Format[Action] = new Format[Action] {

    def tag(t: String) = Json.obj("tag" -> JsString(t))
    def player(p: Player) = Json.obj("player" -> playerFormat.writes(p))

    override def writes(o: Action): JsValue = o match {
      case NoOp => tag("NoOp")
      case SetPlayer(p) => tag("SetPlayer") ++ player(p)
      case UpdatePlayers(players) => tag("UpdatePlayers") ++ Json.obj("players" -> JsArray(players.map(playerFormat.writes)))
      case NewMessage(p, c) => tag("NewMessage") ++ player(p) ++ Json.obj("content" -> JsString(c))
    }

    override def reads(json: JsValue): JsResult[Action] = json \ "tag" match {

//      case JsArray(Seq(JsString("SetPlayer"), jsonPlayer)) =>
//        playerFormat.reads(jsonPlayer).map(SetPlayer)
//
//      case JsArray(Seq(JsString("PlayerJoin"), jsonPlayer)) =>
//        playerFormat.reads(jsonPlayer).map(PlayerJoin)
//
//      case JsArray(Seq(JsString("PlayerQuit"), jsonPlayer)) =>
//        playerFormat.reads(jsonPlayer).map(PlayerQuit)
//
//      case JsArray(Seq(JsString("Message"), jsonPlayer, JsString(content))) =>
//        playerFormat.reads(jsonPlayer).map(player => Message(player, content))

      case _ => JsSuccess(NoOp)
    }

  }
}
