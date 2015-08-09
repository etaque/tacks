package controllers

import scala.concurrent.duration._
import akka.util.Timeout
import play.api.libs.concurrent.Execution.Implicits._
import akka.actor.ActorRef
import akka.pattern.{ ask, pipe }
import org.joda.time.DateTime
import play.api.libs.json.{JsString, JsValue, Json, Format}
import play.api.mvc.{Controller, WebSocket}
import play.api.mvc.WebSocket.FrameFormatter
import play.api.Play.current
import reactivemongo.bson.BSONObjectID

import models._
import models.JsonFormats._
import tools.JsonFormats.idFormat
import actors._
import dao._

object WebSockets extends Controller with Security {

  implicit val timeout = Timeout(5.seconds)

  import Frames._
  implicit val inputFrameFormatter = FrameFormatter.jsonFrame[InputFrame]
  implicit val outputFrameFormatter = FrameFormatter.jsonFrame[OutputFrame]

  def trackPlayer(trackId: String) = WebSocket.tryAcceptWithActor[InputFrame, OutputFrame] { implicit request =>
    for {
      player <- PlayerAction.getPlayer(request)
      track <- TrackDAO.findById(trackId)
      ref <- (RacesSupervisor.actorRef ? GetTrackActorRef(track)).mapTo[ActorRef]
    }
    yield Right(PlayerActor.props(ref, player)(_))
  }

  implicit val notifEventFormat: Format[NotificationEvent] = Json.format[NotificationEvent]
  implicit val notifEventFrameFormatter = FrameFormatter.jsonFrame[NotificationEvent]

  def notifications = WebSocket.tryAcceptWithActor[JsValue, NotificationEvent] { implicit request =>
    for {
      player <- PlayerAction.getPlayer(request)
    }
    yield Right(NotifiableActor.props(player)(_))
  }


  // import Chat.actionFormat
  // implicit val messageFrameFormatter = FrameFormatter.jsonFrame[Message]
  // implicit val newMessageFrameFormatter = FrameFormatter.jsonFrame[NewMessage]

  // def chat = WebSocket.tryAcceptWithActor[NewMessage, Message] { implicit request =>
  //   for {
  //     player <- PlayerAction.getPlayer(request)
  //   }
  //   yield Right(ChatPlayerActor.props(player)(_))
  // }

}
