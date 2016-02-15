package dao

import java.util.UUID
import org.joda.time.DateTime
import play.api.libs.json._

import DB.api._
import models._
import models.forum._
import models.JsonFormats.courseFormat
import scala.concurrent.Future


class TopicTable(tag: Tag) extends Table[Topic](tag, "forum_topics") {

  def id = column[UUID]("id", O.PrimaryKey)
  def title = column[String]("title")
  def postId = column[Option[UUID]]("post_id")
  def postsCount = column[Int]("posts_count")
  def creationTime = column[DateTime]("creation_time")
  def activityTime = column[DateTime]("activity_time")

  def post = foreignKey(tableName + "_post_fk", postId, Posts)(_.id.?)

  def * = (id, title, postId, postsCount, creationTime, activityTime) <> (Topic.tupled, Topic.unapply)
}

object Topics extends TableQuery(new TopicTable(_)) {

  def listWithUser(): Future[Seq[(Topic, User)]] = DB.run {
    (for {
      topic <- all.sortBy(_.activityTime.desc)
      post <- Posts if topic.postId === post.id
      user <- Users if post.userId === user.id
    } yield (topic, user)).result
  }

  def find(id: UUID): Future[Option[Topic]] = DB.run {
    onId(id).result.headOption
  }

  def createWithPost(topic: Topic, post: Post): Future[Seq[Int]] = DB.run {
    val saveTopic = all += topic
    val savePost = dao.Posts.all += post
    val updateTopicPostId =
      onId(topic.id).map(_.postId).update(Some(post.id))
    DBIO.sequence(Seq(saveTopic, savePost, updateTopicPostId)).transactionally
  }

  def onId(id: UUID) =
    filter(_.id === id)

  def all =
    map(identity)

  def name =
    baseTableRow.tableName
}


