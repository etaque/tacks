package controllers

import java.util.UUID
import play.api.Play
import play.api.db.slick.DatabaseConfigProvider
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
import play.api.i18n.Messages.Implicits._

import actors._
import models._
import models.JsonFormats._
import slick.driver.JdbcProfile
import tools.future.Implicits._
import tools.JsonErrors

import scala.util.Try

object Tracks extends Controller with Security {

  implicit val timeout = Timeout(5.seconds)

  def show(id: UUID) = PlayerAction.async() { implicit request =>
    dao.Tracks.findById(id).map {
      case Some(track) => Ok(Json.toJson(track))
      case None => NotFound
    }
  }

  def drafts = PlayerAction.async() { implicit request =>
    dao.Tracks.listByCreatorId(request.player.id).map { tracks =>
      Ok(Json.toJson(tracks.filter(_.isDraft)))
    }
  }

  def createDraft() = PlayerAction.async(parse.json) { implicit request =>
    asUser {  user =>
      val id = UUID.randomUUID()
      val name = (request.body \ "name").asOpt[String].getOrElse(id.toString)
      val track = Track(
        id = id,
        name = name,
        creatorId = user.id,
        course = Course.spawn,
        status = TrackStatus.draft,
        creationTime = DateTime.now,
        updateTime = DateTime.now
      )
      dao.Tracks.save(track).map { _ =>
        Ok(Json.toJson(track))
      }
    }
  }

  case class UpdateTrack(
    course: Course,
    name: String
  )

  implicit val updateTrackFormat: Format[UpdateTrack] = Json.format[UpdateTrack]

  def update(id: UUID) = PlayerAction.async(parse.json) { implicit request =>
    dao.Tracks.findById(id).flatMap {
      _.filter(canUpdate).map { track =>
        request.body.validate(updateTrackFormat).fold(
          errors => Future.successful(BadRequest(JsonErrors.format(errors))),
          {
            case UpdateTrack(course, name) => {
              for {
                _ <- dao.Tracks.updateFromEditor(track.id, name, course)
              } yield {
                val newTrack = track.copy(course = course, name = name)
                RacesSupervisor.actorRef ! ReloadTrack(newTrack)
                Ok(Json.toJson(newTrack))
              }
            }
          }
        )
      }.getOrElse(Future.successful(BadRequest))
    }
  }

  def publish(id: UUID) = PlayerAction.async(parse.json) { implicit request =>
    dao.Tracks.findById(id).flatMap {
      _.filter(canUpdate).map { track =>
        dao.Tracks.publish(id).map { _ =>
          val newTrack = track.copy(status = TrackStatus.open)
          RacesSupervisor.actorRef ! ReloadTrack(newTrack)
          Ok(Json.toJson(newTrack))
        }
      }.getOrElse(Future.successful(BadRequest))
    }
  }

  def delete(id: UUID) = PlayerAction.async(parse.json) { implicit request =>
    dao.Tracks.findById(id).flatMap {
      _.filter(canUpdate).map { track =>
        dao.Tracks.remove(id).map { _ =>
          Ok(Json.obj())
        }
      }.getOrElse(Future.successful(BadRequest))
    }
  }

  private def canUpdate(track: Track)(implicit request: PlayerRequest[_]) = {
    request.player.isAdmin || (track.isDraft && request.player.id == track.creatorId)
  }

}
