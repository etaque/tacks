package dao

import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._
import org.joda.time.DateTime
import reactivemongo.bson._
import reactivemongo.core.commands._

import tools.BSONHandlers.BSONDateTimeHandler

import models._

object TrackDAO extends MongoDAO[Track] {
  val collectionName = "tracks"

  def findBySlug(slug: String): Future[Option[Track]] = {
    collection.find(BSONDocument("slug" -> slug)).one[Track]
  }

  def updateCourse(id: BSONObjectID, course: Course): Future[_] = {
    update(id, BSONDocument("course" -> course))
  }

  def ensureIndexes(): Unit = {
    import reactivemongo.api.indexes.Index
    import reactivemongo.api.indexes.IndexType._

    collection.indexesManager.ensure(Index(
      key = List("slug" -> Ascending),
      unique = true))
  }

  implicit val bsonReader: BSONDocumentReader[Track] = Macros.reader[Track]
  implicit val bsonWriter: BSONDocumentWriter[Track] = Macros.writer[Track]
}
