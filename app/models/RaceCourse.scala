package models

import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._
import org.joda.time.DateTime
import reactivemongo.bson._
import reactivemongo.core.commands._

import tools.BSONHandlers.BSONDateTimeHandler


case class Track(
  _id: BSONObjectID,
  slug: String,
  course: Course,
  countdown: Int,
  startCycle: Int
) extends HasId

object Track extends MongoDAO[Track] {
  val collectionName = "tracks"

  def findBySlug(slug: String): Future[Option[Track]] = {
    collection.find(BSONDocument("slug" -> slug)).one[Track]
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


case class TrackRun(
  _id: BSONObjectID,
  trackId: BSONObjectID,
  startTime: DateTime,
  playerIds: Seq[BSONObjectID],
  leaderboard: Seq[PlayerTally]
) extends HasId {
  def removePlayerId(id: BSONObjectID): TrackRun = {
    copy(playerIds = playerIds.filterNot(_ == id))
  }
}

object TrackRun extends MongoDAO[TrackRun] {
  val collectionName = "trackRuns"

  def upsert(run: TrackRun): Future[Option[BSONDocument]] = {
    val q = BSONDocument("_id" -> run.id)
    val u = Update(bsonWriter.write(run), fetchNewObject = true)
    db.command(FindAndModify(collectionName, q, u, upsert = true))
  }

  def listByTrack(trackId: BSONObjectID): Future[Seq[TrackRun]] = {
    list(BSONDocument("trackId" -> trackId), BSONDocument("startTime" -> -1))
  }

  def ensureIndexes(): Unit = {
    import reactivemongo.api.indexes.Index
    import reactivemongo.api.indexes.IndexType._

    collection.indexesManager.ensure(Index(
      key = List("leaderboard.playerId" -> Ascending),
      unique = true))

    collection.indexesManager.ensure(Index(
      key = List("trackId" -> Ascending)))
  }

  implicit val playerTallyHandler = Macros.handler[PlayerTally]

  implicit val bsonReader: BSONDocumentReader[TrackRun] = Macros.reader[TrackRun]
  implicit val bsonWriter: BSONDocumentWriter[TrackRun] = Macros.writer[TrackRun]
}
