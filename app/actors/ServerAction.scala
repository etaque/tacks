package actors

import java.util.UUID
import play.api.libs.json._

import models._
import models.JsonFormats._


object ServerAction {

  sealed trait Action
  case class PushRaceUpdate(raceUpdate: RaceUpdate) extends Action
  case class BroadcastMessage(message: Message) extends Action
  case class BroadcastLiveTrack(liveTrack: LiveTrack) extends Action

  implicit val actionFormat: Format[Action] = new Format[Action] {

    def tag(t: String) = Json.obj("tag" -> JsString(t))

    override def writes(f: Action): JsValue = f match {
      case PushRaceUpdate(update) =>
        tag("RaceUpdate") ++ Json.obj("raceUpdate" -> Json.toJson(update))
      case BroadcastMessage(message) =>
        tag("Message") ++ Json.obj("message" -> Json.toJson(message))
      case BroadcastLiveTrack(liveTrack) =>
        tag("LiveTrack") ++ Json.obj("liveTrack" -> Json.toJson(liveTrack))
    }

    override def reads(json: JsValue): JsResult[Action] =
      JsError("Not implemented")
  }
}
