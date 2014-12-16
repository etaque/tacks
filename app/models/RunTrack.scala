package models

import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._
import reactivemongo.bson._
import reactivemongo.core.commands.LastError


case class TrackPoint(
  ms: Int,
  p: Geo.Point,
  h: Double
)

case class RunTrack(
  _id: BSONObjectID = BSONObjectID.generate,
  runId: BSONObjectID,
  second: Long,
  points: Seq[TrackPoint]
) extends HasId {
}

object RunTrack extends MongoDAO[RunTrack] {
  val collectionName = "run_tracks"

  import Geo._
  implicit val trackPointHandler = Macros.handler[TrackPoint]

  implicit val bsonReader: BSONDocumentReader[RunTrack] = Macros.reader[RunTrack]
  implicit val bsonWriter: BSONDocumentWriter[RunTrack] = Macros.writer[RunTrack]

  def listForRun(runId: BSONObjectID): Future[Seq[RunTrack]] =
    list(BSONDocument("runId" -> runId), BSONDocument("second" -> 1))

  def removeRun(runId: BSONObjectID): Future[LastError] =
    collection.remove(BSONDocument("runId" -> runId), firstMatchOnly = false)
}
