package controllers

import scala.concurrent.duration._
import scala.concurrent.{Await, Future}
import play.api.data._
import play.api.data.Forms._
import play.api.mvc._
import play.api.libs.concurrent.Execution.Implicits._
import models.{CreateUser, Race, User}

object Users extends Controller with Security {

  val userForm = Form(
    mapping(
      "email" -> email
        .verifying("error.emailTaken", email => Await.result(User.findByEmail(email), 5.seconds).isEmpty),
      "password" -> text(minLength = 6),
      "handle" -> text(minLength = 3)
        .verifying("error.handleFormat", handle => handle.isEmpty || handle.matches("""\A[a-zA-Z0-9_-]*\Z"""))
        .verifying("error.handleTaken", handle => Await.result(User.findByHandle(handle), 5.seconds).isEmpty)
    )(CreateUser.apply)(CreateUser.unapply)
  )

  def creation = Identified.apply() { implicit request =>
    Ok(views.html.users.creation(userForm))
  }

  def create = Identified.async() { implicit request =>
    userForm.bindFromRequest.fold(
      withErrors => Future.successful(BadRequest(views.html.users.creation(withErrors))),
      {
        case CreateUser(email, password, handle) => {
          val user = User(email = email, handle = handle, status = None)
          User.create(user, password).map { _ => Redirect(routes.Application.index).withSession("playerId" -> user.idToStr) }
        }
      }
    )
  }

  def show(id: String) = Identified.async() { implicit request =>
    for {
      user <- User.findById(id)
      races <- Race.listByUserId(user.id)
      opponents <- User.listByIds(races.flatMap(_.tally.map(_.playerId)))
    }
    yield Ok(views.html.users.show(user, races, opponents))
  }

  def updateStatus = Identified.async(parse.urlFormEncoded) { implicit request =>
    val statusOption = request.body.get("status").flatMap(_.headOption).filter(_.nonEmpty)
    User.updateStatus(request.player.id, statusOption).map { _ =>
      Redirect(routes.Application.index)
    }
  }
}
