package controllers

import java.util.UUID
import org.jsoup.safety.Whitelist
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
// import models.JsonFormats._
import tools.future.Implicits._
import tools.JsonErrors

import scala.util.Try
import org.jsoup.Jsoup

object Forum extends Controller with Security {

  implicit val userWrites = JsonFormats.userWrites
  implicit val topicFormat: Format[Topic] = Json.format[Topic]
  implicit val postFormat: Format[Post] = Json.format[Post]

  implicit val uiTopicWrites: Writes[UiTopic] =
    Json.writes[UiTopic]

  implicit val uiPostWrites: Writes[UiPost] =
    Json.writes[UiPost]

  private def sanitize(raw: String): String = {
    Jsoup.clean(raw, Whitelist.basic)
  }


  def topics = UserAction.async() { implicit request =>
    dao.Topics.listWithUser().map { topics =>
      Ok(Json.toJson(topics.map(UiTopic.tupled)))
    }
  }

  def topic(id: UUID) = UserAction.async() { implicit request =>
    onTopic(id) { topic =>
      dao.Posts.listByTopicIdWithUser(id).map { postsWithUsers =>
        val json = Json.obj(
          "topic" -> Json.toJson(topic),
          "postsWithUsers" -> Json.toJson(postsWithUsers.map(UiPost.tupled))
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
    (__ \ "title").read[String](minLength[String](2)) and
      (__ \ "content").read[String](minLength[String](2).map(sanitize))
  )(CreateTopic.apply _)

  def createTopic = UserAction.async(parse.json) { implicit request =>
    request.body.validate(createTopicReads).fold(
      errors => Future.successful(BadRequest(JsonErrors.format(errors))),
      {
        case form @ CreateTopic(title, content) => {
          val postId = UUID.randomUUID()
          val now = DateTime.now()
          val topic = Topic(
            id = UUID.randomUUID(),
            title = title,
            postId = None,
            postsCount = 1,
            creationTime = now,
            activityTime = now
          )
          val post = Post(
            id = postId,
            topicId = topic.id,
            userId = request.user.id,
            content = content,
            creationTime = now,
            updateTime = now
          )
          Topics.createWithPost(topic, post).map { _ =>
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
    (__ \ "content").read[String](minLength[String](2)).map(sanitize).map(CreatePost.apply _)

  def createPost(topicId: UUID) = UserAction.async(parse.json) { implicit request =>
    onTopic(topicId) { topic =>
      request.body.validate(createPostReads).fold(
        errors => Future.successful(BadRequest(JsonErrors.format(errors))),
        {
          case form @ CreatePost(content) => {
            val post = Post(
              id = UUID.randomUUID(),
              topicId = topicId,
              userId = request.user.id,
              content = content,
              creationTime = DateTime.now,
              updateTime = DateTime.now
            )
            Posts.createOnTopic(post, topic).map { _ =>
              Ok(Json.toJson(UiPost(post, request.user)))
            }
          }
        }
      )
    }
  }

  private def onTopic[A](id: UUID)(f: Topic => Future[Result])(implicit req: UserRequest[A]): Future[Result] = {
    dao.Topics.find(id).flatMap {
      case Some(topic) => f(topic)
      case None => Future.successful(NotFound)
    }
  }

}
