package controllers

import org.joda.time.DateTime

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration._
import play.api.data.Form
import play.api.data.Forms._
import play.api.mvc._
import akka.util.Timeout
import akka.pattern.{ ask, pipe }

import actors.{MountRace, GetPublicRaces, RacesSupervisor}
import models.{Course, Race}

object Application extends Controller with Security {

  val signupForm = Form(tuple(
    "email" -> email,
    "password" -> nonEmptyText,
    "name" -> nonEmptyText
  ))

  implicit val timeout = Timeout(5.seconds)

  def index = Identified.async() { implicit request =>
    (RacesSupervisor.actorRef ? GetPublicRaces).mapTo[Seq[(Race, Option[DateTime])]].map { racesWithStart =>
      Ok(views.html.index(racesWithStart))
    }
  }

  def createRace = Identified.async() { implicit request =>
    val isPrivate = request.getQueryString("isPrivate").exists(_.toBoolean)
    val race = Race(userId = getUserId, course = Course.default, isPrivate = isPrivate, countdownSeconds = 30)

    (RacesSupervisor.actorRef ? MountRace(race)).map { _ =>
      Redirect(routes.Game.playRace(race.id.stringify))
    }
  }

}

