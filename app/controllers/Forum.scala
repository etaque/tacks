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
import play.api.i18n.Messages.Implicits._
import akka.util.Timeout
import org.joda.time.DateTime

import slick.dbio.DBIO
import slick.driver.JdbcProfile

import actors._
import models._
import models.forum._
import dao._
import dao.DB.api._
import models.JsonFormats._
import tools.future.Implicits._
import tools.JsonErrors

import scala.util.Try

object Forum extends Controller with Security {

  implicit val topicFormat: Format[Topic] = Json.format[Topic]

  implicit val topicWithOriginalFormat: Format[TopicWithOriginal] =
    Json.format[TopicWithOriginal]

  implicit val postFormat: Format[Post] = Json.format[Post]

  implicit val postWithUserFormat: Format[PostWithUser] =
    Json.format[PostWithUser]


  def topics = PlayerAction.async() { implicit request =>
    dao.Topics.listWithOriginal().map { topics =>
      Ok(Json.toJson(topics.map(TopicWithOriginal.tupled)))
    }
  }

  def topic(id: UUID) = PlayerAction.async() { implicit request =>
    onTopic(id) { topic =>
      dao.Posts.listByTopicIdWithUsers(id).map { postsWithUsers =>
        val json = Json.obj(
          "topic" -> Json.toJson(topic),
          "postsWithUsers" -> Json.toJson(postsWithUsers.map(PostWithUser.tupled))
        )
        Ok(json)
      }
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
          val postId = UUID.randomUUID()
          val topic = Topic(
            id = UUID.randomUUID(),
            title = title,
            postId = Some(postId)
          )
          val post = Post(
            id = postId,
            topicId = topic.id,
            userId = request.player.id,
            content = content,
            creationTime = DateTime.now,
            updateTime = DateTime.now
          )
          Topics.createWithOriginal(topic, post).map { _ =>
            Ok(Json.toJson(topic))
          }
        }
      }
    )
  }

  case class CreatePost(
    content: String
  )

  implicit val createPostReads =
    (__ \ "content").read[String].map(CreatePost.apply _)

  def createPost(topicId: UUID) = PlayerAction.async(parse.json) { implicit request =>
    onTopic(topicId) { topic =>
      request.body.validate(createPostReads).fold(
        errors => Future.successful(BadRequest(JsonErrors.format(errors))),
        {
          case form @ CreatePost(content) => {
            val post = Post(
              id = UUID.randomUUID(),
              topicId = topicId,
              userId = request.player.id,
              content = content,
              creationTime = DateTime.now,
              updateTime = DateTime.now
            )
            Posts.save(post).map { _ => Ok(Json.toJson(post)) }
          }
        }
      )
    }
  }

  private def onTopic[A](id: UUID)(f: Topic => Future[Result])(implicit req: PlayerRequest[A]): Future[Result] = {
    dao.Topics.find(id).flatMap {
      case Some(topic) => f(topic)
      case None => Future.successful(NotFound)
    }
  }

}
