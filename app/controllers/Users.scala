package controllers

import com.sksamuel.scrimage.Image
import play.api.cache.Cache
import play.api.libs.iteratee.Enumerator
import play.api.libs.json.Json
import play.modules.reactivemongo.MongoController
import reactivemongo.api.gridfs.DefaultFileToSave
import reactivemongo.bson.BSONObjectID
import reactivemongo.api.gridfs.Implicits._
import scala.concurrent.duration._
import scala.concurrent.{Await, Future}
import play.api.data._
import play.api.data.Forms._
import play.api.mvc._
import play.api.libs.concurrent.Execution.Implicits._
import models.{Avatar, CreateUser, Race, User}

object Users extends Controller with Security with MongoController {

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

  def creation = PlayerAction.apply() { implicit request =>
    Ok(views.html.users.creation(userForm))
  }

  def create = PlayerAction.async() { implicit request =>
    userForm.bindFromRequest.fold(
      withErrors => Future.successful(BadRequest(views.html.users.creation(withErrors))),
      {
        case CreateUser(email, password, handle) => {
          val user = User(email = email, handle = handle, status = None, avatarId = None)
          User.create(user, password).map { _ => Redirect(routes.Application.index).withSession("playerId" -> user.idToStr) }
        }
      }
    )
  }

  def show(id: String) = PlayerAction.async() { implicit request =>
    for {
      user <- User.findById(id)
      races <- Race.listByUserId(user.id)
      opponents <- User.listByIds(races.flatMap(_.tally.map(_.playerId)))
    }
    yield Ok(views.html.users.show(user, races, opponents))
  }

  def edit = PlayerAction.async() { implicit request =>
    asUser { user =>
      Future.successful(Ok(views.html.users.edit(user)))
    }
  }

  def updateStatus = PlayerAction.async(parse.urlFormEncoded) { implicit request =>
    val statusOption = request.body.get("status").flatMap(_.headOption).filter(_.nonEmpty)
    User.updateStatus(request.player.id, statusOption).map { _ =>
      Redirect(routes.Application.index())
    }
  }

  def uploadAvatar = PlayerAction.async(parse.multipartFormData) { implicit request =>
    asUser { user =>
      request.body.file("avatar") match {
        case Some(tempFile) if tempFile.contentType.fold(false)(Avatar.contentTypes.contains) => {
          val fileToSave = DefaultFileToSave(tempFile.filename, tempFile.contentType)
          val resizedFile = Image(tempFile.ref.file).cover(320, 320).write
          val enumerator = Enumerator(resizedFile)

          for {
            file <- Avatar.store.save(enumerator, fileToSave)
            id = file.id.asInstanceOf[BSONObjectID]
            _ <- Avatar.removeOpt(user.avatarId)
            _ <- User.updateAvatarId(user.id, Some(id))
          }
          yield {
            Ok(Json.obj("url" -> routes.Users.showAvatar(id.stringify).url))
          }
        }
        case _ => Future.successful(BadRequest)
      }
    }
  }

  def removeAvatar = PlayerAction.async() { implicit request =>
    asUser { user =>
      for {
        _ <- Avatar.removeOpt(user.avatarId)
        _ <- User.updateAvatarId(user.id, None)
      }
      yield Redirect(routes.Users.edit())
    }
  }

  def showAvatar(id: String) = Action.async {
    val cursor = Avatar.read(BSONObjectID(id))
    serve(Avatar.store, cursor).map(_.withHeaders(CONTENT_DISPOSITION -> CONTENT_DISPOSITION_INLINE))
  }
}
