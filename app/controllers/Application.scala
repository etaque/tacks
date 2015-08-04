package controllers

import scala.concurrent.Future
import scala.concurrent.duration._
import play.api.libs.concurrent.Execution.Implicits._
import play.api.mvc._
import play.api.Play.current

object Application extends Controller with Security {

  def index(path: String = "") = PlayerAction.async() { implicit request =>
    Future.successful(Ok(views.html.index()))
  }

  def notFound(path: String) = PlayerAction.async() { implicit request =>
    Future.successful(NotFound)
  }

}

