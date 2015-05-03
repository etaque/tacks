package models

import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._
import org.joda.time.DateTime
import reactivemongo.bson._
import reactivemongo.core.commands._

import tools.BSONHandlers.BSONDateTimeHandler


case class RaceCourse(
  _id: BSONObjectID,
  slug: String,
  course: Course,
  countdown: Int,
  startCycle: Int
) extends HasId

object RaceCourse extends MongoDAO[RaceCourse] {
  val collectionName = "raceCourses"

  def findBySlug(slug: String): Future[Option[RaceCourse]] = {
    collection.find(BSONDocument("slug" -> slug)).one[RaceCourse]
  }

  def ensureIndexes(): Unit = {
    import reactivemongo.api.indexes.Index
    import reactivemongo.api.indexes.IndexType._

    collection.indexesManager.ensure(Index(
      key = List("slug" -> Ascending),
      unique = true))
  }

  implicit val bsonReader: BSONDocumentReader[RaceCourse] = Macros.reader[RaceCourse]
  implicit val bsonWriter: BSONDocumentWriter[RaceCourse] = Macros.writer[RaceCourse]
}


case class RaceCourseRun(
  _id: BSONObjectID,
  raceCourseId: BSONObjectID,
  startTime: DateTime,
  playerIds: Seq[BSONObjectID],
  leaderboard: Seq[PlayerTally]
) extends HasId {
  def removePlayerId(id: BSONObjectID): RaceCourseRun = {
    copy(playerIds = playerIds.filterNot(_ == id))
  }
}

object RaceCourseRun extends MongoDAO[RaceCourseRun] {
  val collectionName = "raceCourseRuns"

  def upsert(run: RaceCourseRun): Future[Option[BSONDocument]] = {
    val q = BSONDocument("_id" -> run.id)
    val u = Update(bsonWriter.write(run), fetchNewObject = true)
    db.command(FindAndModify(collectionName, q, u, upsert = true))
  }

  def listByRaceCourse(raceCourseId: BSONObjectID): Future[Seq[RaceCourseRun]] = {
    list(BSONDocument("raceCourseId" -> raceCourseId), BSONDocument("startTime" -> -1))
  }

  def ensureIndexes(): Unit = {
    import reactivemongo.api.indexes.Index
    import reactivemongo.api.indexes.IndexType._

    collection.indexesManager.ensure(Index(
      key = List("leaderboard.playerId" -> Ascending),
      unique = true))

    collection.indexesManager.ensure(Index(
      key = List("raceCourseId" -> Ascending)))
  }

  implicit val playerTallyHandler = Macros.handler[PlayerTally]

  implicit val bsonReader: BSONDocumentReader[RaceCourseRun] = Macros.reader[RaceCourseRun]
  implicit val bsonWriter: BSONDocumentWriter[RaceCourseRun] = Macros.writer[RaceCourseRun]
}
