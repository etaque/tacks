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

  def createRace = Identified.async(parse.json) { implicit request =>
    val isPrivate = request.getQueryString("isPrivate").exists(_.toBoolean)
    val race = Race(userId = getUserId, course = Course.default, isPrivate = isPrivate, countdownSeconds = 30)
    val master = User(getUserId, getUserName.getOrElse("Anonymous"))

    (RacesSupervisor.actorRef ? MountRace(race, master)).map { _ =>
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
    val user = User(getUserId, getUserName.getOrElse("Anonymous"))
    Ok(Json.toJson(user))
  }

  import models.JsonFormats._
  implicit val boatUpdateFrameFormatter = FrameFormatter.jsonFrame[PlayerInput]
  implicit val raceUpdateFrameFormatter = FrameFormatter.jsonFrame[RaceUpdate]

  def playerSocket(raceId: String) = WebSocket.tryAcceptWithActor[PlayerInput, RaceUpdate] { request =>
    request.session.get("userId") match {
      case None => Future.successful(Left(Unauthorized))
      case Some(userId) => {
        val user = User(BSONObjectID(userId), request.session.get("playerName").getOrElse("Anonymous"))
        (RacesSupervisor.actorRef ? GetRaceActorRef(BSONObjectID(raceId))).mapTo[Option[ActorRef]].map {
          case Some(raceActor) => Right(PlayerActor.props(raceActor, user)(_))
          case None => Left(NotFound)
        }
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
