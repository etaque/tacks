package controllers

import core.{WarmUp, CourseGenerator}
import play.api.libs.concurrent.Execution.Implicits._
import scala.concurrent.Future
import scala.concurrent.duration._
import play.api.mvc._
import play.api.libs.json._
import play.api.libs.functional.syntax._
import play.api.libs.json.Reads._
import play.api.Play.current
import akka.util.Timeout
import akka.pattern.{ ask, pipe }
import org.joda.time.DateTime
import reactivemongo.bson.BSONObjectID

import actors._
import models._
import dao._
import models.JsonFormats._
import tools.future.Implicits._

import scala.util.Try

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
            credentials <- UserDAO.getHashedPassword(email).map(UserDAO.checkPassword(password))
            if credentials
            user <- UserDAO.findByEmail(email).flattenOpt
          }
          yield {
            Ok(playerFormat.writes(user)).withSession("playerId" -> user.idToStr)
          }) recover {
            case _ => BadRequest("Wrong user or password")
          }
        }
      }
    )
  }

  def logout = Action.async(parse.json) { request =>
    val newPlayer = Guest(BSONObjectID.generate)
    Future.successful(Ok(
      playerFormat.writes(newPlayer)).withSession("playerId" -> newPlayer.id.stringify))
  }

  def currentPlayer = PlayerAction.async() { request =>
    Future.successful(Ok(playerFormat.writes(request.player)))
  }


  case class RegisterForm(
    handle: String,
    email: String,
    password: String
  )

  implicit val registerReads = (
    (__ \ "handle").read[String](minLength[String](3)) and
      (__ \ "email").read[String](email) and
      (__ \ "password").read[String](minLength[String](3))
  )(RegisterForm.apply _)

  def register = Action.async(parse.json) { implicit request =>
    request.body.validate(registerReads).fold(
      errors => Future.successful(BadRequest), // TODO
      {
        case form @ RegisterForm(handle, email, password) => {
          for {
            emailTaken <- UserDAO.findByEmail(email).map(_.nonEmpty)
            handleTaken <- UserDAO.findByHandleOpt(handle).map(_.nonEmpty)
            result <- handleRegisterForm(form, emailTaken, handleTaken)
          }
          yield result
        }
      }
    )
  }

  def handleRegisterForm(form: RegisterForm, emailTaken: Boolean, handleTaken: Boolean): Future[Result] = {
    if (emailTaken || handleTaken) {
      Future.successful(BadRequest) // TODO
    } else {
      val user = User(email = form.email, handle = form.handle, status = None, avatarId = None, vmgMagnet = Player.defaultVmgMagnet)
      UserDAO.create(user, form.password).map { _ =>
        Ok(Json.toJson(user)(playerFormat)).withSession("playerId" -> user.idToStr)
      }

    }

  }


  def liveStatus = PlayerAction.async() { implicit request =>
    val tracksFu = (RacesSupervisor.actorRef ? GetTracks).mapTo[Seq[LiveTrack]]
    val onlinePlayersFu = (LiveCenter.actorRef ? GetOnlinePlayers).mapTo[Seq[Player]]
    for {
      tracks <- tracksFu
      onlinePlayers <- onlinePlayersFu
    }
    yield Ok(Json.obj(
      "liveTracks" -> Json.toJson(tracks),
      "onlinePlayers" -> Json.toJson(onlinePlayers)
    ))
  }

  def track(slug: String) = PlayerAction.async() { implicit request =>
    TrackDAO.findBySlug(slug).map {
      case Some(track) => Ok(Json.toJson(track))
      case None => NotFound
    }
  }

  def liveTrack(slug: String) = PlayerAction.async() { implicit request =>
    (RacesSupervisor.actorRef ? GetTracks).mapTo[Seq[LiveTrack]].map { liveTracks =>
      liveTracks.find(_.track.slug == slug) match {
        case Some(rcs) => Ok(Json.toJson(rcs))
        case None => NotFound
      }
    }

  }

  def setHandle = PlayerAction(parse.json) { implicit request =>
    (request.body \ "handle").asOpt[String] match {
      case Some(handle) => Ok(playerFormat.writes(Guest(request.player.id, Some(handle)))).addingToSession("playerHandle" -> handle)
      case None => BadRequest
    }
  }

}
