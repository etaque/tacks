package controllers

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
import tools.JsonErrors

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
      errors => Future.successful(BadRequest(JsonErrors.format(errors))), // TODO
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
      val emailError = if (emailTaken) JsonErrors.one("email", "error.emailTaken") else Json.obj()
      val handleError = if (handleTaken) JsonErrors.one("handle", "error.handleTaken") else Json.obj()
      Future.successful(BadRequest(emailError ++ handleError))
    } else {
      val user = User(email = form.email, handle = form.handle, status = None, avatarId = None, vmgMagnet = Player.defaultVmgMagnet)
      UserDAO.create(user, form.password).map { _ =>
        Ok(Json.toJson(user)(playerFormat)).withSession("playerId" -> user.idToStr)
      }
    }
  }


  def liveStatus = PlayerAction.async() { implicit request =>
    val tracksFu = (RacesSupervisor.actorRef ? GetTracks).mapTo[Seq[LiveTrack]]
    val draftsFu = TrackDAO.listByCreatorId(request.player.id).map(_.filter(_.isDraft))
    val onlinePlayersFu = (LiveCenter.actorRef ? GetOnlinePlayers).mapTo[Seq[Player]]
    for {
      tracks <- tracksFu
      homeLiveTracks = tracks.filter(_.track.isOpen).sortBy(_.meta.rankings.length).reverse
      drafts <- draftsFu
      onlinePlayers <- onlinePlayersFu
    }
    yield Ok(Json.obj(
      "liveTracks" -> Json.toJson(homeLiveTracks),
      "drafts" -> Json.toJson(drafts),
      "onlinePlayers" -> Json.toJson(onlinePlayers)
    ))
  }

  def track(id: String) = PlayerAction.async() { implicit request =>
    TrackDAO.findByIdOpt(id).map {
      case Some(track) => Ok(Json.toJson(track))
      case None => NotFound
    }
  }

  def liveTrack(id: String) = PlayerAction.async() { implicit request =>
    (RacesSupervisor.actorRef ? GetTracks).mapTo[Seq[LiveTrack]].map { liveTracks =>
      liveTracks.find(_.track.id == BSONObjectID(id)) match {
        case Some(rcs) => Ok(Json.toJson(rcs))
        case None => NotFound
      }
    }
  }

  def drafts = PlayerAction.async() { implicit request =>
    TrackDAO.listByCreatorId(request.player.id).map { tracks =>
      Ok(Json.toJson(tracks.filter(_.isDraft)))
    }
  }

  def createDraftTrack() = PlayerAction.async(parse.json) { implicit request =>
    if (request.player.isAdmin) {
      val id = BSONObjectID.generate
      val name = (request.body \ "name").asOpt[String].getOrElse(id.stringify)
      val track = Track(
        _id = id,
        name = name,
        creatorId = request.player.id,
        course = Course.spawn,
        status = TrackStatus.draft
      )
      TrackDAO.save(track).map { _ =>
        Ok(Json.toJson(track))
      }
    } else {
      Future.successful(Forbidden)
    }
  }

  case class UpdateTrack(
    course: Course,
    name: String
  )

  implicit val updateTrackFormat: Format[UpdateTrack] = Json.format[UpdateTrack]

  def updateTrack(id: String) = PlayerAction.async(parse.json) { implicit request =>
    TrackDAO.findById(id).flatMap { track =>
      if (canUpdateTrack(track)) {
        request.body.validate(updateTrackFormat).fold(
          errors => Future.successful(BadRequest(JsonErrors.format(errors))),
          {
            case UpdateTrack(course, name) => {
              for {
                _ <- TrackDAO.updateFromEditor(track.id, name, course)
              } yield {
                val newTrack = track.copy(course = course, name = name)
                RacesSupervisor.actorRef ! ReloadTrack(newTrack)
                Ok(Json.toJson(newTrack))
              }
            }
          }
        )
      } else {
        Future.successful(Forbidden)
      }
    }
  }

  def publishTrack(id: String) = PlayerAction.async(parse.json) { implicit request =>
    TrackDAO.findById(id).flatMap { track =>
      if (canUpdateTrack(track)) {
        TrackDAO.publish(BSONObjectID(id)).map { _ =>
          val newTrack = track.copy(status = TrackStatus.open)
          RacesSupervisor.actorRef ! ReloadTrack(newTrack)
          Ok(Json.toJson(newTrack))
        }
      } else {
        Future.successful(BadRequest)
      }
    }
  }

  def deleteTrack(id: String) = PlayerAction.async(parse.json) { implicit request =>
    TrackDAO.findById(id).flatMap { track =>
      if (canUpdateTrack(track)) {
        TrackDAO.remove(id).map { _ =>
          Ok(Json.obj())
        }
      } else {
        Future.successful(BadRequest)
      }
    }
  }

  private def canUpdateTrack(track: Track)(implicit request: PlayerRequest[_]) = {
    request.player.isAdmin || (track.isDraft && request.player.id == track.creatorId)
  }

  def setHandle = PlayerAction(parse.json) { implicit request =>
    (request.body \ "handle").asOpt[String] match {
      case Some(handle) => Ok(playerFormat.writes(Guest(request.player.id, Some(handle)))).addingToSession("playerHandle" -> handle)
      case None => BadRequest
    }
  }

  def admin = PlayerAction.async(parse.anyContent) { implicit request =>
    asAdmin { user =>
      for {
        tracks <- TrackDAO.list
        users <- UserDAO.list
      }
      yield Ok(Json.obj(
        "tracks" -> Json.toJson(tracks),
        "users" -> Json.toJson(users)(fullUserSeqFormat)
      ))
    }
  }
}
