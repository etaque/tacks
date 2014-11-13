package controllers

import play.api.libs.concurrent.Execution.Implicits._
import scala.concurrent.Future
import scala.concurrent.duration._
import play.api.mvc._
import play.api.mvc.WebSocket.FrameFormatter
import play.api.libs.json._
import play.api.libs.functional.syntax._
import play.api.Play.current
import akka.actor.ActorRef
import akka.util.Timeout
import akka.pattern.{ ask, pipe }
import org.joda.time.DateTime
import reactivemongo.bson.BSONObjectID

import actors._
import models._
import models.JsonFormats._
import tools.future.Implicits._

object Api extends Controller with Security {

  implicit val timeout = Timeout(5.seconds)

  implicit val loginReads = (
    (__ \ "email").read[String] and
      (__ \ "password").read[String]
    ).tupled

  def login = Action.async(parse.json) { implicit request =>
    request.body.validate(loginReads).fold(
      errors => Future.successful(BadRequest),
      {
        case (email, password) => {
          (for {
            credentials <- User.getHashedPassword(email).map(User.checkPassword(password))
            if credentials
            user <- User.findByEmail(email).flattenOpt
          }
          yield {
            Ok.withSession("playerId" -> user.idToStr)
          }) recover {
            case _ => BadRequest
          }
        }
      }
    )
  }

  def racesStatus = Identified.async() { implicit request =>
    val racesFuture = (RacesSupervisor.actorRef ? GetOpenRaces).mapTo[Seq[RaceStatus]]
    val onlinePlayersFuture = (ChatRoom.actorRef ? GetOnlinePlayers).mapTo[Seq[Player]]
    val finishedRacesFuture = Race.listFinished(10)
    for {
      openRaces <- racesFuture
      onlinePlayers <- onlinePlayersFuture
      finishedRaces <- finishedRacesFuture
      userIds = finishedRaces.flatMap(_.tally.map(_.playerId)).distinct
      users <- User.listByIds(userIds)
    }
    yield Ok(Json.obj(
      "now" -> DateTime.now,
      "openRaces" -> Json.toJson(openRaces),
      "onlinePlayers" -> Json.toJson(onlinePlayers),
      "finishedRaces" -> Json.toJson(finishedRaces),
      "users" -> users.map(u => Json.toJson(u)(userFormat)) // conflict with playerFormat
    ))
  }

  def onlinePlayers = Identified.async() { implicit request =>
    (ChatRoom.actorRef ? GetOnlinePlayers).mapTo[Seq[Player]].map { players =>
      Ok(Json.toJson(players))
    }
  }

  def createRace = Identified.async(parse.json) { implicit request =>
    val race = Race(playerId = getPlayerId, course = Course.spawn, countdownSeconds = 60)

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
  implicit val playerInputFrameFormatter = FrameFormatter.jsonFrame[PlayerInput]
  implicit val watcherInputFrameFormatter = FrameFormatter.jsonFrame[WatcherInput]
  implicit val raceUpdateFrameFormatter = FrameFormatter.jsonFrame[RaceUpdate]

  def playerSocket(raceId: String) = WebSocket.tryAcceptWithActor[PlayerInput, RaceUpdate] { implicit request =>
    Identified.getPlayer(request).flatMap { player =>
      (RacesSupervisor.actorRef ? GetRaceActorRef(BSONObjectID(raceId))).mapTo[Option[ActorRef]].map {
        case Some(raceActor) => Right(PlayerActor.props(raceActor, player)(_))
        case None => Left(NotFound)
      }
    }
  }

  def watcherSocket(raceId: String) = WebSocket.tryAcceptWithActor[WatcherInput, RaceUpdate] { implicit request =>
    Identified.getPlayer(request).flatMap { watcher =>
      (RacesSupervisor.actorRef ? GetRaceActorRef(BSONObjectID(raceId))).mapTo[Option[ActorRef]].map {
        case Some(raceActor) => Right(WatcherActor.props(raceActor, watcher)(_))
        case None => Left(NotFound)
      }
    }
  }

}
