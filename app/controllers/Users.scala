package controllers

import controllers.Api._
import play.api.libs.json.Json

import scala.concurrent.duration._
import models.{CreateUser, Race, User}
import play.api.data._
import play.api.data.Forms._
import play.api.data.validation.{Valid, ValidationError, Invalid, Constraint}
import play.api.mvc._
import play.api.libs.concurrent.Execution.Implicits._
import tools.future.Implicits._
import scala.concurrent.{Await, Future}

object Users extends Controller with Security {

  val uniqueEmailConstraint: Constraint[String] = Constraint("constraints.uniqueEmail")({
    email =>
      Await.result(User.findByEmail(email), 5.seconds) match {
        case Some(_) => Invalid(Seq(ValidationError("Email already used.")))
        case None => Valid
      }
  })

  val handleFormatConstraint: Constraint[String] = Constraint("constraints.handleFormat")({ handle =>
    if (handle.isEmpty || handle.matches("^[a-z0-9_-]{3,15}$")) Valid
    else Invalid(Seq(ValidationError("Handle must be alphanumeric.")))
  })

  val uniqueHandleConstraint: Constraint[String] = Constraint("constraints.uniqueHandle")({
    handle =>
      Await.result(User.findByHandle(handle), 5.seconds) match {
        case Some(_) => Invalid(Seq(ValidationError("Handle already taken.")))
        case None => Valid
      }
  })

  val userForm = Form(
    mapping(
      "email" -> email.verifying(uniqueEmailConstraint),
      "password" -> nonEmptyText(minLength = 6),
      "handle" -> nonEmptyText(minLength = 2).verifying(handleFormatConstraint).verifying(uniqueHandleConstraint)
    )(CreateUser.apply)(CreateUser.unapply)
  )

  def create = Action.async { implicit request =>
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

  def show(handle: String) = Action.async { implicit request =>
    for {
      user <- User.findByHandle(handle).flattenOpt
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
