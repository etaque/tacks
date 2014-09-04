package controllers

import reactivemongo.bson.BSONObjectID

import scala.concurrent.duration._
import scala.concurrent.ExecutionContext.Implicits.global
import play.api.mvc._
import play.api.mvc.WebSocket.FrameFormatter
import play.api.Play.current
import akka.actor.ActorRef
import akka.util.Timeout
import akka.pattern.ask

import actors._
import models._

object Game extends Controller with Security {

  implicit val timeout = Timeout(5.seconds)

  def playRace(id: String) = Identified.async() { implicit request =>
    (RacesSupervisor.actorRef ? GetRace(BSONObjectID(id))).mapTo[Option[Race]].map {
      case Some(race) => {
        val websocketUrlBase = "ws://" + request.host
        val playerName = getUserName.getOrElse("Anonymous")
        Ok(views.html.playRace(race, playerName, websocketUrlBase))
      }
      case None => Redirect(routes.Application.index())
    }
  }

  import models.JsonFormats._
  implicit val boatUpdateFrameFormatter = FrameFormatter.jsonFrame[PlayerInput]
  implicit val raceUpdateFrameFormatter = FrameFormatter.jsonFrame[RaceUpdate]

  def socket(raceId: String, playerId: String) = WebSocket.tryAcceptWithActor[PlayerInput, RaceUpdate] { request =>
    (RacesSupervisor.actorRef ? GetRaceActorRef(BSONObjectID(raceId))).mapTo[Option[ActorRef]].map {
      case Some(raceActor) => Right(PlayerActor.props(raceActor, playerId)(_))
      case None => Left(NotFound)
    }
  }
}

