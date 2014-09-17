package controllers

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future
import scala.concurrent.duration._
import play.api.mvc._
import play.api.mvc.WebSocket.FrameFormatter
import play.api.libs.json.Json
import play.api.Play.current
import akka.actor.ActorRef
import akka.util.Timeout
import akka.pattern.{ ask, pipe }
import org.joda.time.DateTime
import reactivemongo.bson.BSONObjectID

import actors._
import models._
import models.JsonFormats._
import models.Race.mongoFormat


object Api extends Controller with Security {

  implicit val timeout = Timeout(5.seconds)

  def racesStatus = Identified.async() { implicit request =>
    (RacesSupervisor.actorRef ? GetOpenRaces).mapTo[Seq[RaceStatus]].map { races =>
      Ok(Json.obj(
        "now" -> DateTime.now,
        "races" -> Json.toJson(races)))
    }
  }

  def onlinePlayers = Identified.async() { implicit request =>
    (ChatRoom.actorRef ? GetOnlinePlayers).mapTo[Seq[Player]].map { players =>
      Ok(Json.toJson(players))
    }
  }

  def createRace = Identified.async(parse.json) { implicit request =>
    val isPrivate = request.getQueryString("isPrivate").exists(_.toBoolean)
    val race = Race(playerId = getPlayerId, course = Course.spawn, isPrivate = isPrivate, countdownSeconds = 60)

    (RacesSupervisor.actorRef ? MountRace(race, request.player)).map { _ =>
      Ok(Json.toJson(race))
    }
  }

  def setName = Identified(parse.json) { implicit request =>
    (request.body \ "name").asOpt[String] match {
      case Some(name) => Ok(Json.obj()).addingToSession("playerName" -> name)
      case None => BadRequest
    }
  }

  def currentUser = Identified() { implicit request =>
    Ok(Json.toJson(request.player))
  }

  import models.JsonFormats._
  implicit val boatUpdateFrameFormatter = FrameFormatter.jsonFrame[PlayerInput]
  implicit val raceUpdateFrameFormatter = FrameFormatter.jsonFrame[RaceUpdate]

  def playerSocket(raceId: String) = WebSocket.tryAcceptWithActor[PlayerInput, RaceUpdate] { implicit request =>
    Identified.getPlayer(request).flatMap { player =>
      (RacesSupervisor.actorRef ? GetRaceActorRef(BSONObjectID(raceId))).mapTo[Option[ActorRef]].map {
        case Some(raceActor) => Right(PlayerActor.props(raceActor, player)(_))
        case None => Left(NotFound)
      }
    }
  }

  def getRace(raceId: String) = Identified.async() { implicit request =>
    (RacesSupervisor.actorRef ? GetRace(BSONObjectID(raceId))).mapTo[Option[Race]].map {
      case None => NotFound
      case Some(race) => Ok(Json.obj(
        "race" -> Json.toJson(race),
        "initialUpdate" -> Json.toJson(RaceUpdate.initial(race))
      ))
    }
  }
}
