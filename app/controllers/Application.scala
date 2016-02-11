package controllers

import scala.concurrent.Future
import scala.concurrent.duration._
import play.api.libs.concurrent.Execution.Implicits._
import play.api.mvc._
import play.api.Play.current

import models._
import dao._


object Application extends Controller with Security {

  def index(path: String = "") = PlayerAction.async() { implicit request =>
    Future.successful(Ok(views.html.index()))
  }

  def notFound(path: String) = PlayerAction.async() { implicit request =>
    Future.successful(NotFound)
  }

  // def showAvatar(id: String) = Action.async {
  //   val cursor = AvatarDAO.read(BSONObjectID(id))
  //   serve(AvatarDAO.store, cursor).map(_.withHeaders(
  //     CONTENT_DISPOSITION -> CONTENT_DISPOSITION_INLINE,
  //     ETAG -> id,
  //     CACHE_CONTROL -> "max-age=290304000"
  //   ))
  // }
}

