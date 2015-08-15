package dao

import play.api.libs.concurrent.Execution.Implicits._
import org.joda.time.{LocalDate, DateTime}
import reactivemongo.bson._
import reactivemongo.core.commands._
import tools.BSONHandlers.BSONDateTimeHandler

import scala.concurrent.Future
import scala.util.Try

import models._


object RunDAO extends MongoDAO[Run] {
  val collectionName = "runs"

  def updateTimes(id: BSONObjectID, tally: Seq[Long], finishTime: Option[Long]): Future[_] = {
    update(id, BSONDocument("tally" -> tally, "finishTime" -> finishTime))
  }

  def listRecent(trackId: BSONObjectID, count: Int): Future[Seq[Run]] = {
    collection.find(BSONDocument("trackId" -> trackId, "finishTime" -> BSONDocument("$exists" -> true)))
      .sort(BSONDocument("startTime" -> -1))
      .cursor[Run].collect[Seq](upTo = count)
  }

  def countForTrack(trackId: BSONObjectID): Future[Int] = {
    count(Some(BSONDocument("trackId" -> trackId)))
  }


  implicit val bsonReader: BSONDocumentReader[Run] = Macros.reader[Run]
  implicit val bsonWriter: BSONDocumentWriter[Run] = Macros.writer[Run]
}

