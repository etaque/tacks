package controllers

import scala.concurrent.ExecutionContext.Implicits.global
import play.api.mvc.{Action, Controller}
import models._
import play.api.data.Form
import play.api.data.Forms._

import scala.concurrent.Future

object Auth extends Controller {

  val loginForm = Form(tuple(
    "email" -> email,
    "password" -> nonEmptyText
  ))

  def login = Action { implicit request =>
    Ok(views.html.login(loginForm))
  }

  def loginPost = Action.async { implicit request =>
    val form = loginForm.bindFromRequest()
    form.fold(
      formWithErrors => Future.successful(BadRequest(views.html.login(formWithErrors))),
      {
        case (email, password) => User.findForLogin(email, password).map {
          case Some(user) => Redirect(routes.Application.index).withSession("email" -> email)
          case None => BadRequest(views.html.login(form))
        }
      }
    )
  }

  def logout = Action {
    Redirect(routes.Auth.login).withNewSession
  }

}
