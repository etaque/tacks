package models

import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._
import org.joda.time.DateTime
import reactivemongo.bson._

import tools.BSONHandlers.BSONDateTimeHandler

case class PlayerTally(player: Player, gates: Seq[DateTime])

case class Race (
  _id: BSONObjectID = BSONObjectID.generate,
  playerId: BSONObjectID,
  isPrivate: Boolean,
  course: Course,
  countdownSeconds: Int,
  creationTime: DateTime = DateTime.now,
  startTime: Option[DateTime] = None,
  tally: Seq[PlayerTally] = Nil
) extends HasId {
  def ranking = tally.sortBy(_.gates.headOption.map(_.getMillis)).map(_.player)
}

object Race extends MongoDAO[Race] {
  val collectionName = "races"

  def updateStartTime(race: Race, time: DateTime): Future[_] = {
    update(race.id, BSONDocument("startTime" -> BSONDateTimeHandler.write(time)))
  }

  def updateTally(race: Race, tally: Seq[PlayerTally]): Future[_] = {
    update(race.id, BSONDocument("tally" -> tally.map(playerTallyHandler.write)))
  }

  def listFinished(count: Int): Future[Seq[Race]] = {
    collection.find(BSONDocument()).sort(BSONDocument("startTime" -> -1)).cursor[Race].collect[Seq](count)
  }

  implicit val playerTallyHandler = Macros.handler[PlayerTally]

  implicit val bsonReader: BSONDocumentReader[Race] = Macros.reader[Race]
  implicit val bsonWriter: BSONDocumentWriter[Race] = Macros.writer[Race]
}
