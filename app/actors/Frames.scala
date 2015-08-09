package actors

import play.api.libs.json._

import models._
import models.JsonFormats._


// TODO more typesafety

object Frames {

  sealed trait InputFrame
  case class PlayerInputFrame(raceInput: PlayerInput) extends InputFrame
  case class NewMessageFrame(content: String) extends InputFrame

  implicit val inputFrameFormat: Format[InputFrame] = new Format[InputFrame] {

    override def writes(f: InputFrame): JsValue = Json.obj()

    override def reads(json: JsValue): JsResult[InputFrame] = json \ "tag" match {
      case JsString("PlayerInput") =>
        JsSuccess(PlayerInputFrame((json \ "playerInput").as[PlayerInput]))
      case JsString("NewMessage") =>
        JsSuccess(NewMessageFrame((json \ "content").as[String]))
      case _ =>
        JsError("Unkown InputFrame tag")
    }

  }


  sealed trait OutputFrame
  case class RaceUpdateFrame(raceUpdate: RaceUpdate) extends OutputFrame
  case class BroadcastMessageFrame(message: Message) extends OutputFrame

  implicit val outputFrameFormat: Format[OutputFrame] = new Format[OutputFrame] {

    def tag(t: String) = Json.obj("tag" -> JsString(t))

    override def writes(f: OutputFrame): JsValue = f match {
      case RaceUpdateFrame(update) => tag("RaceUpdate") ++ Json.obj("raceUpdate" -> Json.toJson(update))
      case BroadcastMessageFrame(message) => tag("BroadcastMessage") ++ Json.obj("message" -> Json.toJson(message))
      case _ => Json.obj()
    }

    override def reads(json: JsValue): JsResult[OutputFrame] = JsError("Not implemented")
  }

}
