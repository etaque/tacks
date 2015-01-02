package controllers

import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._
import play.api.mvc.{Action, Controller}
import play.api.Play.current
import play.api.i18n.Messages
import models.User
import tools.future.Implicits._

object Auth extends Controller with Security {

  def askLogin = Identified.async() { implicit request =>
    val failure = request.flash.get("failure")
    Future.successful(Ok(views.html.auth.login(failure)))
  }

  def submitLogin = Action.async { implicit request =>

    val form = for {
      data     <- request.body.asFormUrlEncoded
      email    <- data.get("email").flatMap(_.headOption)
      password <- data.get("password").flatMap(_.headOption)
    }
    yield (email, password)

    (for {
      (email, password) <- Future(form).filter(_.isDefined).map(_.get)
      credentials <- User.getHashedPassword(email).map(User.checkPassword(password))
      if credentials
      user <- User.findByEmail(email).flattenOpt
    }
    yield {
      Redirect(routes.Application.index).withSession(
        "playerId" -> user.idToStr
      )
    }) recover { case _ =>
      Redirect(routes.Auth.askLogin()).withNewSession.flashing("failure" -> Messages("login.failed"))
    }
  }

  def logout() = Action {
    Redirect(routes.Application.index()).withNewSession
  }

}
