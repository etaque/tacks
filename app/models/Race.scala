package models

import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._
import org.joda.time.DateTime
import reactivemongo.bson._

import tools.BSONHandlers.BSONDateTimeHandler

case class PlayerTally(
  playerId: BSONObjectID,
  playerHandle: Option[String],
  gates: Seq[Long]
)

case class Race (
  _id: BSONObjectID = BSONObjectID.generate,
  playerId: BSONObjectID,
  course: Course,
  generator: String,
  countdownSeconds: Int,
  creationTime: DateTime = DateTime.now,
  startTime: Option[DateTime] = None,
  tally: Seq[PlayerTally] = Nil
) extends HasId {
  def ranking = tally.sortBy(_.gates.headOption).map(_.playerId)
}

object Race extends MongoDAO[Race] {
  val collectionName = "races"

  def updateTally(race: Race, tally: Seq[PlayerTally]): Future[_] = {
    update(race.id, BSONDocument("tally" -> tally.map(playerTallyHandler.write)))
  }

  def listFinished(count: Int): Future[Seq[Race]] = {
    collection.find(BSONDocument())
      .sort(BSONDocument("startTime" -> -1))
      .cursor[Race].collect[Seq](count)
  }

  def listByUserId(userId: BSONObjectID): Future[Seq[Race]] = {
    collection.find(BSONDocument("tally.playerId" -> userId))
      .sort(BSONDocument("startTime" -> -1))
      .cursor[Race].collect[Seq]()
  }

  def ensureIndexes(): Unit = {
    import reactivemongo.api.indexes.Index
    import reactivemongo.api.indexes.IndexType._

    collection.indexesManager.ensure(Index(
      key = List("tally.playerId" -> Ascending),
      unique = true))
  }

  implicit val playerTallyHandler = Macros.handler[PlayerTally]

  implicit val bsonReader: BSONDocumentReader[Race] = Macros.reader[Race]
  implicit val bsonWriter: BSONDocumentWriter[Race] = Macros.writer[Race]
}

