package dao

import play.api.libs.concurrent.Execution.Implicits._
import org.joda.time.{LocalDate, DateTime}
import reactivemongo.bson._
import reactivemongo.core.commands._
import tools.BSONHandlers.BSONDateTimeHandler

import scala.concurrent.Future
import scala.util.Try

import models._


object RunPathDAO extends MongoDAO[RunPath] {
  val collectionName = "runPaths"

  def findByRunId(runId: BSONObjectID): Future[Option[RunPath]] = {
    collection.find(BSONDocument("runId" -> runId)).one[RunPath]
  }

  def deleteByRunId(runId: BSONObjectID): Future[LastError] = {
    collection.remove(BSONDocument("runId" -> runId))
  }

  import Geo._
  implicit val pathPointHandler: BSONHandler[BSONDocument, PathPoint] = Macros.handler[PathPoint]

  implicit val pathHandler = new BSONHandler[BSONDocument, Map[Long, Seq[PathPoint]]] {
    def read(doc: BSONDocument) = {
      doc.elements.map { case (key, value) =>
        val second = key.asInstanceOf[Long]
        val points = value.asInstanceOf[BSONArray].values
          .map(_.asInstanceOf[BSONDocument].as[PathPoint](pathPointHandler)).toSeq
        second -> points
      }.toMap
    }

    def write(path: Map[Long, Seq[PathPoint]]) = {
      BSONDocument(path.map { case (s, points) => s.toString -> BSONArray(points.map(pathPointHandler.write)) }.toSeq)
    }
  }

  implicit val bsonReader: BSONDocumentReader[RunPath] = Macros.reader[RunPath]
  implicit val bsonWriter: BSONDocumentWriter[RunPath] = Macros.writer[RunPath]
}
