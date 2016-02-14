package dao

import java.util.UUID
import org.joda.time.DateTime
import play.api.libs.json._

import DB.api._
import models._
import models.forum._
import models.JsonFormats.courseFormat
import scala.concurrent.Future


class PostTable(tag: Tag) extends Table[Post](tag, "forum_posts") {

  def id = column[UUID]("id", O.PrimaryKey)
  def topicId = column[UUID]("topic_id")
  def userId = column[UUID]("user_id")
  def content = column[String]("content")
  def creationTime = column[DateTime]("creation_time")
  def updateTime = column[DateTime]("update_time")

  def user = foreignKey("user_fk", userId, Users)(_.id)

  def * = (id, topicId, userId, content, creationTime, updateTime) <> (Post.tupled, Post.unapply)
}


object Posts extends TableQuery(new PostTable(_)) {

  def list(): Future[Seq[Post]] = DB.run {
    all.result
  }

  def find(id: UUID): Future[Option[Post]] = DB.run {
    onId(id).result.headOption
  }

  def listByTopicId(id: UUID): Future[Seq[Post]] = DB.run {
    filter(_.topicId === id).result
  }

  def listByTopicIdWithUsers(topicId: UUID): Future[Seq[(Post, User)]] = DB.run {
    filter(_.topicId === topicId)
      .join(Users).on(_.userId === _.id)
      .result
  }
  def save(post: Post): Future[Int] = DB.run {
    all += post
  }

  def remove(id: UUID): Future[Int] = DB.run {
    onId(id).delete
  }

  def onId(id: UUID) =
    filter(_.id === id)

  def all =
    map(identity)
}
