package controllers


import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration._
import play.api.data.Form
import play.api.data.Forms._
import play.api.mvc._
import akka.util.Timeout
import akka.pattern.{ ask, pipe }

import actors._

import models.{User, Race}



object Application extends Controller {

  val signupForm = Form(tuple(
    "email" -> email,
    "password" -> nonEmptyText,
    "name" -> nonEmptyText
  ))

  implicit val timeout = Timeout(5.seconds)

  def index = Action.async {
    (RacesSupervisor.actorRef ? GetNextRace).map {
      case Some(nextRace: Race) => Ok(views.html.index(Some(nextRace)))
    }
  }

  def signup = Action { request =>
    Ok
  }

  def signupPost = Action.async { implicit request =>
    val form = signupForm.bindFromRequest()
    form.fold(
      formWithErrors => Future.successful(BadRequest(views.html.signup(formWithErrors))),
      {
        case (email, password, name) => User.insertPlain(email, password, name).map { user =>
          Redirect(routes.Application.index).withSession("email" -> email)
        }
      }
    )
  }

}

