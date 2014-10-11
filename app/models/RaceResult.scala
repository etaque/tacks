package models

import reactivemongo.bson._
import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._

case class RaceResult(
  _id: BSONObjectID = BSONObjectID.generate,
  raceId: BSONObjectID,
  userId: BSONObjectID,
  rank: Int,
  ms: Long
) extends HasId

object RaceResult extends MongoDAO[RaceResult] {
  val collectionName = "results"

  def listByUserId(userId: BSONObjectID): Future[Seq[RaceResult]] = {
    collection.find(BSONDocument("userId" -> userId)).cursor[RaceResult].collect[Seq]()
  }

  implicit val bsonReader: BSONDocumentReader[RaceResult] = Macros.reader[RaceResult]
  implicit val bsonWriter: BSONDocumentWriter[RaceResult] = Macros.writer[RaceResult]
}
