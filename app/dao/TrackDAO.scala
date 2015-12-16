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

  def updateFromEditor(id: BSONObjectID, name: String, course: Course): Future[_] = {
    update(id, BSONDocument("name" -> name, "course" -> course))
  }

  def listByCreatorId(id: BSONObjectID): Future[Seq[Track]] = {
    list(BSONDocument("creatorId" -> id))
  }

  def ensureIndexes(): Unit = {
    import reactivemongo.api.indexes.Index
    import reactivemongo.api.indexes.IndexType._

    collection.indexesManager.ensure(Index(
      key = List("name" -> Ascending),
      unique = true))
  }

  import TrackStatus.handler

  implicit val bsonReader: BSONDocumentReader[Track] = Macros.reader[Track]
  implicit val bsonWriter: BSONDocumentWriter[Track] = Macros.writer[Track]
}
