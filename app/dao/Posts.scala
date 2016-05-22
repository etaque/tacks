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

  def find(id: UUID): Future[Option[Post]] = DB.run {
    onId(id).result.headOption
  }

  def listByTopicIdWithUser(topicId: UUID): Future[Seq[(Post, User)]] = DB.run {
    filter(_.topicId === topicId)
      .join(Users).on(_.userId === _.id)
      .sortBy(_._1.creationTime.asc)
      .result
  }

  def createOnTopic(post: Post, topic: Topic): Future[(Int, Int)] = DB.run {
    val savePost = dao.Posts.all += post
    val updateTopic = sqlu"""
      UPDATE #${Topics.name}
      SET
        posts_count = (SELECT COUNT(id) FROM #$name WHERE topic_id = ${topic.id}),
        activity_time = ${post.creationTime}
      WHERE id = ${topic.id}
      """
    savePost.zip(updateTopic).transactionally

  }

  def remove(id: UUID): Future[Int] = DB.run {
    onId(id).delete
  }

  def onId(id: UUID) =
    filter(_.id === id)

  // def onTopicId(id: UUID) =
  //   filter(_.topicId === id)

  def all =
    map(identity)

  def name =
    baseTableRow.tableName
}
