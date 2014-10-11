package controllers

import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._
import play.api.mvc.{Action, Controller}
import models.User
import tools.future.Implicits._

object Auth extends Controller {

  def askLogin = Action.async { request =>
    val failure = request.flash.get("failure")
    Future.successful(Ok(views.html.auth.login(failure)))
  }

  def submitLogin = Action.async { request =>

    val form = for {
      data     <- request.body.asFormUrlEncoded
      email    <- data.get("email").flatMap(_.headOption)
      password <- data.get("password").flatMap(_.headOption)
    }
    yield (email, password)

    (for {
      (email, password) <- Future(form).filter(_.isDefined).map(_.get)
      credentials <- User.getPassword(email).map(User.checkPassword(password))
      if credentials
      user <- User.findByEmail(email).flattenOpt
    }
    yield {
      Redirect(routes.Application.index).withSession(
        "playerId" -> user.idToStr
      )
    }) recover { case _ =>
      Redirect(routes.Auth.askLogin()).withNewSession.flashing("failure" -> "Wrong email and/or password.")
    }
  }

  def logout() = Action {
    Redirect(routes.Application.index()).withNewSession
  }

}
