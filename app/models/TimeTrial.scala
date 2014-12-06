package models

import play.api.libs.concurrent.Execution.Implicits._
import org.joda.time.{LocalDate, DateTime}
import reactivemongo.bson._
import reactivemongo.core.commands._
import tools.BSONHandlers.BSONDateTimeHandler

import scala.concurrent.Future

case class TimeTrial(
  _id: BSONObjectID = BSONObjectID.generate,
  slug: String,
  course: Course,
  countdownSeconds: Int = 20
) extends HasId

object TimeTrial extends MongoDAO[TimeTrial] {
  val collectionName = "time_trials"

  def findBySlug(slug: String): Future[Option[TimeTrial]] = {
    collection.find(BSONDocument("slug" -> slug)).one[TimeTrial]
  }

  def ensureIndexes(): Unit = {
    import reactivemongo.api.indexes.Index
    import reactivemongo.api.indexes.IndexType._

    collection.indexesManager.ensure(Index(
      key = List("slug" -> Ascending),
      unique = true))
  }

  implicit val bsonReader: BSONDocumentReader[TimeTrial] = Macros.reader[TimeTrial]
  implicit val bsonWriter: BSONDocumentWriter[TimeTrial] = Macros.writer[TimeTrial]
}


case class TimeTrialRun(
  _id: BSONObjectID = BSONObjectID.generate,
  timeTrialId: BSONObjectID,
  playerId: BSONObjectID,
  tally: Seq[Long] = Nil,
  finishTime: Option[Long] = None
) extends HasId

case class RunRanking(
  playerId: BSONObjectID,
  runId: BSONObjectID,
  finishTime: Long
)

object TimeTrialRun extends MongoDAO[TimeTrialRun] {
  val collectionName = "time_trial_runs"

  def updateTimes(id: BSONObjectID, tally: Seq[Long], finishTime: Option[Long]): Future[_] = {
    update(id, BSONDocument("tally" -> tally, "finishTime" -> finishTime))
  }

  def ranking(trialId: BSONObjectID): Future[Seq[RunRanking]] = {
    val cmd = Aggregate(collectionName, Seq(
      Match(BSONDocument("timeTrialId" -> trialId, "finishTime" -> BSONDocument("$exists" -> true))),
      Sort(Seq(Ascending("finishTime"))),
      GroupMulti("playerId" -> "playerId")("runId" -> First("_id"), "finishTime" -> First("finishTime"))
    ))

    db.command(cmd).map { bsonStream =>
      (for {
        doc <- bsonStream.toSeq
        id <- doc.getAs[BSONDocument]("_id")
        playerId <- id.getAs[BSONObjectID]("playerId")
        finishTime <- doc.getAs[Long]("finishTime")
        runId <- doc.getAs[BSONObjectID]("runId")
      }
      yield RunRanking(playerId, runId, finishTime)).sortBy(_.finishTime)
    }
  }

  def filterClose(playerRanking: RunRanking, allRankings: Seq[RunRanking], count: Int): Seq[RunRanking] = {
    val (fasters, lowers) = allRankings
      .filterNot(_.playerId == playerRanking.playerId)
      .sortBy(_.finishTime)
      .partition(_.finishTime < playerRanking.finishTime)

    (fasters.takeRight(count / 2 + 1) ++ lowers.take(count / 2 + 1)).takeRight(count)
  }

  def findGhosts(trial: TimeTrial, playerRun: TimeTrialRun, count: Int = 5): Future[Seq[GhostRun]] = {
    for {
      ranking <- ranking(trial.id)
      playerRankingOpt = ranking.find(_.playerId == playerRun.playerId)
      selectedRankings = playerRankingOpt match {
        case Some(r) => filterClose(r, ranking, count - 1) :+ r
        case None => scala.util.Random.shuffle(ranking).take(count)
      }
      runs <- listByIds(selectedRankings.map(_.runId))
      tracks <- Future.sequence(runs.map(r => Tracking.getTrack(r.id)))
      players <- User.listByIds(runs.map(_.playerId))
    }
    yield runs.zip(tracks).map { case (run, track) =>
      GhostRun(run, track, players.find(_.id == run.playerId).map(_.handle))
    }
  }

  def clean(runId: BSONObjectID): Future[LastError] = {
    for {
      _ <- Tracking.removeTrack(runId)
      e <- remove(runId)
    }
    yield e
  }

  implicit val bsonReader: BSONDocumentReader[TimeTrialRun] = Macros.reader[TimeTrialRun]
  implicit val bsonWriter: BSONDocumentWriter[TimeTrialRun] = Macros.writer[TimeTrialRun]
}


