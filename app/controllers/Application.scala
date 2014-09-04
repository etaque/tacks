package controllers

import org.joda.time.DateTime

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration._
import play.api.data.Form
import play.api.data.Forms._
import play.api.mvc._
import akka.util.Timeout
import akka.pattern.{ ask, pipe }

import actors.{MountRace, GetPendingRaces, RacesSupervisor}
import models.{Course, Race, User}

object Application extends Controller with Security {

  implicit val timeout = Timeout(5.seconds)

  def index = Identified.async() { implicit request =>
    (RacesSupervisor.actorRef ? GetPendingRaces).mapTo[Seq[(Race, User, Option[DateTime])]].map { racesWithStart =>
      Ok(views.html.index(racesWithStart, getUserName))
    }
  }

  def setName = Identified(parse.urlFormEncoded) { implicit request =>
    request.body.get("name").flatMap(_.headOption) match {
      case Some(name) => Redirect(routes.Application.index).addingToSession("playerName" -> name)
      case None => Redirect(routes.Application.index)
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

