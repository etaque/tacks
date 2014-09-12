package controllers

import org.joda.time.DateTime

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration._
import play.api.data.Form
import play.api.data.Forms._
import play.api.mvc._
import akka.util.Timeout
import akka.pattern.{ ask, pipe }

import actors.{MountRace, GetOpenRaces, RacesSupervisor}
import models.{RaceStatus, Course, Race, User}

object Application extends Controller with Security {

  implicit val timeout = Timeout(5.seconds)

  def index = Identified.async() { implicit request =>
    (RacesSupervisor.actorRef ? GetOpenRaces).mapTo[Seq[(Race, User, RaceStatus)]].map { races =>
      Ok(views.html.index(races, getUserName))
    }
  }

  def setName = Identified(parse.multipartFormData) { implicit request =>
    request.body.dataParts.get("name").flatMap(_.headOption) match {
      case Some(name) => Ok.addingToSession("playerName" -> name)
      case None => BadRequest
    }
  }

  def createRace = Identified.async() { implicit request =>
    val isPrivate = request.getQueryString("isPrivate").exists(_.toBoolean)
    val race = Race(userId = getUserId, course = Course.default, isPrivate = isPrivate, countdownSeconds = 30)
    val master = User(getUserId, getUserName.getOrElse("Anonymous"))

    (RacesSupervisor.actorRef ? MountRace(race, master)).map { _ =>
      Redirect(routes.Game.playRace(race.id.stringify))
    }
  }

}

