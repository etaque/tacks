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

object WebSockets extends Controller with Security {

  implicit val timeout = Timeout(5.seconds)

  implicit val playerInputFrameFormatter = FrameFormatter.jsonFrame[PlayerInput]
  implicit val raceUpdateFrameFormatter = FrameFormatter.jsonFrame[RaceUpdate]

  def timeTrial(timeTrialId: String, time: Long) = WebSocket.tryAcceptWithActor[PlayerInput, RaceUpdate] { implicit request =>
    for {
      player <- PlayerAction.getPlayer(request)
      timeTrial <- TimeTrial.findById(timeTrialId)
      run = TimeTrialRun(
        timeTrialId = timeTrial.id,
        playerId = player.id,
        playerHandle = player.handleOpt,
        time = new DateTime(time)
      )
      ghostRuns <- TimeTrialRun.findGhosts(timeTrial, run)
      timeTrialActor <- (RacesSupervisor.actorRef ? MountTimeTrialRun(timeTrial, player, run)).mapTo[ActorRef]
    }
    yield {
      timeTrialActor ! SetGhostRuns(ghostRuns)
      Right(PlayerActor.props(timeTrialActor, player)(_))
    }
  }

  def racePlayer(raceId: String) = WebSocket.tryAcceptWithActor[PlayerInput, RaceUpdate] { implicit request =>
    PlayerAction.getPlayer(request).flatMap { player =>
      (RacesSupervisor.actorRef ? GetRaceActorRef(BSONObjectID(raceId))).mapTo[Option[ActorRef]].map {
        case Some(raceActor) => Right(PlayerActor.props(raceActor, player)(_))
        case None => Left(NotFound)
      }
    }
  }

  implicit val notifEventFormat: Format[NotificationEvent] = Json.format[NotificationEvent]
  implicit val notifEventFrameFormatter = FrameFormatter.jsonFrame[NotificationEvent]

  def notifications = WebSocket.tryAcceptWithActor[JsValue, NotificationEvent] { implicit request =>
    for {
      player <- PlayerAction.getPlayer(request)
    }
    yield Right(NotifiableActor.props(player)(_))
  }


  import Chat.actionFormat
  implicit val chatActionFrameFormatter = FrameFormatter.jsonFrame[Chat.Action]

  def chatRoom = WebSocket.tryAcceptWithActor[Chat.Action, Chat.Action] { implicit request =>
    for {
      player <- PlayerAction.getPlayer(request)
    }
    yield Right(ChatPlayerActor.props(player)(_))
  }


  implicit val tutorialInputFrameFormatter = FrameFormatter.jsonFrame[TutorialInput]
  implicit val tutorialUpdateFormatter = FrameFormatter.jsonFrame[TutorialUpdate]

  def tutorial = WebSocket.tryAcceptWithActor[TutorialInput, TutorialUpdate] { implicit request =>
    for {
      player <- PlayerAction.getPlayer(request)
      ref <- (RacesSupervisor.actorRef ? MountTutorial(player)).mapTo[ActorRef]
    }
    yield {
      Right(PlayerActor.props(ref, player)(_))
    }
  }

}
