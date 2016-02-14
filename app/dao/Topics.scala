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

  def post = foreignKey("post_fk", postId, Posts)(_.id.?)

  def * = (id, title, postId) <> (Topic.tupled, Topic.unapply)
}

object Topics extends TableQuery(new TopicTable(_)) {

  def list(): Future[Seq[Topic]] = DB.run {
    all.result
  }

  def listWithOriginal(): Future[Seq[(Topic, Post, User)]] = DB.run {
    (for {
      topic <- all
      post <- Posts if topic.postId === post.id
      user <- Users if post.userId === user.id
    } yield (topic, post, user)).result
  }

  def find(id: UUID): Future[Option[Topic]] = DB.run {
    onId(id).result.headOption
  }

  def save(topic: Topic): Future[Int] = DB.run {
    all += topic
  }

  def createWithOriginal(topic: Topic, post: Post): Future[(Int, Int)] = DB.run {
    val saveTopic = dao.Topics.all += topic
    val savePost = dao.Posts.all += post
    saveTopic.zip(savePost).transactionally
  }

  def onId(id: UUID) =
    filter(_.id === id)

  def all =
    map(identity)
}


