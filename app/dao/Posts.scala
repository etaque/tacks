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

  def user = foreignKey(tableName + "_user_fk", userId, Users)(_.id)

  def * = (id, topicId, userId, content, creationTime, updateTime) <> (Post.tupled, Post.unapply)
}


object Posts extends TableQuery(new PostTable(_)) {

  // def list(): Future[Seq[Post]] = DB.run {
  //   all.result
  // }

  def find(id: UUID): Future[Option[Post]] = DB.run {
    onId(id).result.headOption
  }

  // def listByTopicId(id: UUID): Future[Seq[Post]] = DB.run {
  //   filter(_.topicId === id).result
  // }

  def listByTopicIdWithUser(topicId: UUID): Future[Seq[(Post, User)]] = DB.run {
    filter(_.topicId === topicId)
      .join(Users).on(_.userId === _.id)
      .result
  }

  def createOnTopic(post: Post, topic: Topic): Future[(Int, Int)] = DB.run {
    val savePost = dao.Posts.all += post
    val updateTopic = sqlu"""
      UPDATE #${Topics.name}
      SET
        posts_count = (SELECT COUNT FROM $name WHERE id = ${topic.id}),
        activity_time = ${post.creationTime.getMillis}
      WHERE id = ${topic.id}
      """
    savePost.zip(updateTopic).transactionally

  }

  // def save(post: Post): Future[Int] = DB.run {
  //   all += post
  // }

  def remove(id: UUID): Future[Int] = DB.run {
    onId(id).delete
  }

  def onId(id: UUID) =
    filter(_.id === id)

  def onTopicId(id: UUID) =
    filter(_.topicId === id)

  def all =
    map(identity)

  def name =
    baseTableRow.tableName
}
