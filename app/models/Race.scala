package models

import reactivemongo.core.commands.LastError

import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._
import org.joda.time.DateTime
import reactivemongo.bson._

import tools.BSONHandlers.BSONDateTimeHandler

case class PlayerTally(
  playerId: BSONObjectID,
  playerHandle: Option[String],
  gates: Seq[Long]
) extends WithPlayer

case class RaceRanking(
  rank: Int,
  playerId: BSONObjectID,
  playerHandle: Option[String],
  finishTime: Long,
  points: Int
) extends WithPlayer

case class Race (
  _id: BSONObjectID = BSONObjectID.generate,
  playerId: Option[BSONObjectID] = None,
  tournamentId: Option[BSONObjectID] = None,
  course: Course,
  generator: String,
  countdownSeconds: Int = 30,
  creationTime: DateTime = DateTime.now,
  startTime: Option[DateTime] = None,
  tally: Seq[PlayerTally] = Nil,
  mounted: Boolean = false,
  finished: Boolean = false,
  rankings: Seq[RaceRanking] = Nil
) extends HasId {
  def rankedPlayerIds = rankings.map(_.playerId)
}

object Race extends MongoDAO[Race] {
  val collectionName = "races"

  def updateMounted(raceId: BSONObjectID, mounted: Boolean): Future[LastError] = {
    update(raceId, BSONDocument("mounted" -> mounted))
  }

  def setFinished(raceId: BSONObjectID): Future[LastError] = {
    update(raceId, BSONDocument("finished" -> true))
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

  def listByTournamentId(tId: BSONObjectID): Future[Seq[Race]] = {
    collection.find(BSONDocument("tournamentId" -> tId))
      .sort(BSONDocument("startTime" -> -1))
      .cursor[Race].collect[Seq]()
  }

  def listByTournamentIds(ids: Seq[BSONObjectID]): Future[Seq[Race]] = {
    collection.find(BSONDocument("tournamentId" -> BSONDocument("$in" -> ids)))
      .cursor[Race].collect[Seq]()
  }

  def ensureIndexes(): Unit = {
    import reactivemongo.api.indexes.Index
    import reactivemongo.api.indexes.IndexType._

    collection.indexesManager.ensure(Index(
      key = List("tally.playerId" -> Ascending),
      unique = true))

    collection.indexesManager.ensure(Index(
      key = List("tournamentId" -> Ascending)))
  }

  implicit val playerTallyHandler = Macros.handler[PlayerTally]
  implicit val raceRankingHandler = Macros.handler[RaceRanking]

  implicit val bsonReader: BSONDocumentReader[Race] = Macros.reader[Race]
  implicit val bsonWriter: BSONDocumentWriter[Race] = Macros.writer[Race]
}

