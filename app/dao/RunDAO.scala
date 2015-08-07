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

  // def rankings(trackId: BSONObjectID): Future[Seq[RunRanking]] = {
  //   val cmd = Aggregate(collectionName, Seq(
  //     Match(BSONDocument("trackId" -> trackId, "finishTime" -> BSONDocument("$exists" -> true))),
  //     Sort(Seq(Ascending("finishTime"))),
  //     GroupMulti(
  //       "playerId" -> "playerId"
  //     )(
  //       "runId" -> First("_id"),
  //       "playerHandle" -> First("playerHandle"),
  //       "finishTime" -> First("finishTime")
  //     ),
  //     Sort(Seq(Ascending("finishTime")))
  //   ))

  //   db.command(cmd).map { bsonStream =>
  //     for {
  //       (doc, i) <- bsonStream.toSeq.zipWithIndex
  //       id <- doc.getAs[BSONDocument]("_id")
  //       playerId <- id.getAs[BSONObjectID]("playerId")
  //       finishTime <- doc.getAs[Long]("finishTime")
  //       runId <- doc.getAs[BSONObjectID]("runId")
  //       playerHandle = doc.getAs[String]("playerHandle")
  //     }
  //     yield RunRanking(i + 1, playerId, playerHandle, runId, finishTime)
  //   }
  // }

  // def filterClose(playerRanking: RunRanking, allRankings: Seq[RunRanking], count: Int): Seq[RunRanking] = {
  //   val (fasters, lowers) = allRankings
  //     .filterNot(_.playerId == playerRanking.playerId)
  //     .sortBy(_.finishTime)
  //     .partition(_.finishTime < playerRanking.finishTime)

  //   fasters.takeRight(count - 1) ++ lowers.take(1)
  // }

  // def findGhosts(track: TimeTrack, playerRun: Run, count: Int = 5): Future[Seq[GhostRun]] = {
  //   for {
  //     ranking <- rankings(track.id)
  //     playerRankingOpt = ranking.find(_.playerId == playerRun.playerId)
  //     selectedRankings = playerRankingOpt match {
  //       case Some(r) => filterClose(r, ranking, count - 1) :+ r
  //       case None => scala.util.Random.shuffle(ranking).take(count)
  //     }
  //     runs <- listByIds(selectedRankings.map(_.runId))
  //     tracks <- Future.sequence(runs.map(r => RunTrack.listForRun(r.id)))
  //     players <- User.listByIds(runs.map(_.playerId))
  //   }
  //   yield runs.zip(tracks).map { case (run, track) =>
  //     GhostRun(run, track, run.playerId, players.find(_.id == run.playerId).map(_.handle))
  //   }
  // }

  // def clean(runId: BSONObjectID): Future[LastError] = {
  //   for {
  //     _ <- RunTrack.removeRun(runId)
  //     e <- remove(runId)
  //   }
  //   yield e
  // }

  implicit val bsonReader: BSONDocumentReader[Run] = Macros.reader[Run]
  implicit val bsonWriter: BSONDocumentWriter[Run] = Macros.writer[Run]
}

