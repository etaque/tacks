package controllers

import scala.concurrent.Future
import scala.concurrent.duration._
import akka.util.Timeout
import play.api.libs.concurrent.Execution.Implicits._
import play.api.mvc._
import play.api.Play.current

import models._
import dao._


object Application extends Controller with Security {

  implicit val timeout = Timeout(5.seconds)

  def index(path: String = "") = PlayerAction.async() { implicit request =>
    LiveStatus.get().map { liveStatus =>
      Ok(views.html.index(liveStatus))
    }
  }

  def notFound(path: String) = PlayerAction.async() { implicit request =>
    Future.successful(NotFound)
  }
}

