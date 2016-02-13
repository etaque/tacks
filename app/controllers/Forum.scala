package controllers

import java.util.UUID
import play.api.Play
import play.api.db.slick.DatabaseConfigProvider
import play.api.libs.concurrent.Execution.Implicits._
import scala.concurrent.Future
import scala.concurrent.duration._
import play.api.mvc._
import play.api.libs.json._
import play.api.libs.functional.syntax._
import play.api.libs.json.Reads._
import play.api.Play.current
import akka.util.Timeout
import akka.pattern.{ ask, pipe }
import org.joda.time.DateTime
import play.api.i18n.Messages.Implicits._

import actors._
import models._
import dao._
import models.JsonFormats._
import slick.driver.JdbcProfile
import tools.future.Implicits._
import tools.JsonErrors

import scala.util.Try

object Forum extends Controller with Security {

  def topics = PlayerAction.async() { implicit request =>
    dao.ForumPosts.listParents().map { posts =>
      Ok(Json.toJson(posts))
    }
  }

  def topicPosts(id: UUID) = PlayerAction.async() { implicit request =>
    for {
      parentMaybe <- dao.ForumPosts.findById(id)
      posts <- dao.ForumPosts.listByParentId(id)
    }
    yield parentMaybe match {
      case Some(parent) => {
        Ok(Json.toJson(parent +: posts))
      }
      case None => NotFound
    }
  }

  case class CreateTopic(
    title: String,
    content: String
  )

  implicit val createTopicReads = (
    (__ \ "title").read[String] and
      (__ \ "password").read[String]
  )(CreateTopic.apply _)

  def createTopic = PlayerAction.async(parse.json) { implicit request =>
    request.body.validate(createTopicReads).fold(
      errors => Future.successful(BadRequest(JsonErrors.format(errors))),
      {
        case form @ CreateTopic(title, content) => {
          val post = ForumPost(
            id = UUID.randomUUID(),
            title = Some(title),
            parentId = None,
            authorId = request.player.id,
            content = content,
            creationTime = DateTime.now,
            updateTime = DateTime.now
          )
          ForumPosts.save(post).map { _ => Ok(Json.toJson(post)) }
        }
      }
    )
  }

  case class AddPost(
    content: String
  )

  implicit val addPostReads =
    (__ \ "content").read[String].map(AddPost.apply _)

  def addPost(parentId: UUID) = PlayerAction.async(parse.json) { implicit request =>
    dao.ForumPosts.findById(parentId).flatMap {
      case Some(parent) => {
        request.body.validate(addPostReads).fold(
          errors => Future.successful(BadRequest(JsonErrors.format(errors))),
          {
            case form @ AddPost(content) => {
              val post = ForumPost(
                id = UUID.randomUUID(),
                title = None,
                parentId = Some(parentId),
                authorId = request.player.id,
                content = content,
                creationTime = DateTime.now,
                updateTime = DateTime.now
              )
              ForumPosts.save(post).map { _ => Ok(Json.toJson(post)) }
            }
          }
        )
      }
      case None => Future.successful(NotFound)
    }
  }
}
