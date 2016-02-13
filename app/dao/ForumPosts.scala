package dao

import java.util.UUID
import org.joda.time.DateTime
import play.api.libs.json._

import DB.api._
import models._
import models.JsonFormats.courseFormat
import scala.concurrent.Future


class ForumPostTable(tag: Tag) extends Table[ForumPost](tag, "forumPosts") {

  def id = column[UUID]("id", O.PrimaryKey)
  def title = column[Option[String]]("title")
  def parentId = column[Option[UUID]]("parent_id")
  def authorId = column[UUID]("author_id")
  def content = column[String]("content")
  def creationTime = column[DateTime]("creation_time")
  def updateTime = column[DateTime]("update_time")

  def * = (id, title, parentId, authorId, content, creationTime, updateTime) <> (ForumPost.tupled, ForumPost.unapply)
}

object ForumPosts extends TableQuery(new ForumPostTable(_)) {

  def list(): Future[Seq[ForumPost]] = DB.run {
    all.result
  }

  def findById(id: UUID): Future[Option[ForumPost]] = DB.run {
    onId(id).result.headOption
  }

  def listParents(): Future[Seq[ForumPost]] = DB.run {
    filter(_.parentId.isEmpty).result
  }

  def listByParentId(id: UUID): Future[Seq[ForumPost]] = DB.run {
    filter(_.parentId === id).result
  }

  def save(forumPost: ForumPost): Future[Int] = DB.run {
    all += forumPost
  }

  def remove(id: UUID): Future[Int] = DB.run {
    onId(id).delete
  }

  private def onId(id: UUID) =
    filter(_.id === id)

  private def all =
    map(identity)
}
