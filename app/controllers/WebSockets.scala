package controllers

import java.util.UUID
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

import models._
import models.JsonFormats._
import actors._
import dao._


object WebSockets extends Controller with Security {

  implicit val timeout = Timeout(5.seconds)

  import actors.PlayerAction.actionFormat
  implicit val inputFrameFormatter = FrameFormatter.jsonFrame[actors.PlayerAction.Action]
  implicit val outputFrameFormatter = FrameFormatter.jsonFrame[actors.ServerAction.Action]

  def trackPlayer(trackId: UUID) = WebSocket.tryAcceptWithActor[actors.PlayerAction.Action, actors.ServerAction.Action] { implicit request =>
    for {
      player <- PlayerAction.getPlayer(request)
      trackMaybe <- dao.Tracks.findById(trackId)
      track = trackMaybe.getOrElse(sys.error("Track not found"))
      ref <- (RacesSupervisor.actorRef ? SupervisorAction.GetTrackActorRef(track)).mapTo[ActorRef]
    }
    yield Right(PlayerActor.props(ref, player)(_))
  }

  // implicit val notifEventFormat: Format[NotificationEvent] = Json.format[NotificationEvent]
  // implicit val notifEventFrameFormatter = FrameFormatter.jsonFrame[NotificationEvent]

  // def notifications = WebSocket.tryAcceptWithActor[JsValue, NotificationEvent] { implicit request =>
  //   for {
  //     player <- PlayerAction.getPlayer(request)
  //   }
  //   yield Right(NotifiableActor.props(player)(_))
  // }

}
