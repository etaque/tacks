package dao

import play.api.libs.concurrent.Execution.Implicits._
import org.joda.time.{LocalDate, DateTime}
import reactivemongo.bson._
import reactivemongo.core.commands._
import tools.BSONHandlers.BSONDateTimeHandler

import scala.concurrent.Future
import scala.util.Try

import models._


// object RunDAO extends MongoDAO[Run] {
//   val collectionName = "runs"

//   def listRecent(trackId: BSONObjectID, count: Int): Future[Seq[Run]] = {
//     collection.find(BSONDocument("trackId" -> trackId, "finishTime" -> BSONDocument("$exists" -> true)))
//       .sort(BSONDocument("startTime" -> -1))
//       .cursor[Run].collect[Seq](upTo = count)
//   }

//   def countForTrack(trackId: BSONObjectID): Future[Int] = {
//     count(Some(BSONDocument("trackId" -> trackId)))
//   }

//   def listBestForTrack(trackId: BSONObjectID): Future[Seq[Run]] = {
//     collection.find(BSONDocument("trackId" -> trackId))
//       .sort(BSONDocument("finishTime" -> -1))
//       .cursor[Run].collect[Seq]()
//   }

//   def findBestOnTrackForPlayer(trackId: BSONObjectID, playerId: BSONObjectID): Future[Option[Run]] = {
//     collection.find(BSONDocument("playerId" -> playerId, "trackId" -> trackId))
//       .sort(BSONDocument("finishTime" -> -1))
//       .one[Run]
//   }

//   def extractRankings(trackId: BSONObjectID): Future[Seq[RunRanking]] = {
//     val steps = Seq(
//       Match(BSONDocument("trackId" -> trackId)),
//       Sort(Seq(Ascending("finishTime"))),
//       GroupMulti(
//         "playerId" -> "playerId"
//       )(
//         "runId" -> First("_id"),
//         "playerHandle" -> First("playerHandle"),
//         "finishTime" -> First("finishTime")
//       ),
//       Sort(Seq(Ascending("finishTime")))
//     )

//     db.command(Aggregate(collectionName, steps)).map { bsonStream =>
//       for {
//         (doc, i) <- bsonStream.toSeq.zipWithIndex
//         id <- doc.getAs[BSONDocument]("_id")
//         playerId <- id.getAs[BSONObjectID]("playerId")
//         finishTime <- doc.getAs[Long]("finishTime")
//         runId <- doc.getAs[BSONObjectID]("runId")
//         playerHandle = doc.getAs[String]("playerHandle")
//       }
//       yield RunRanking(i + 1, playerId, playerHandle, runId, finishTime)
//     }
//   }

//   implicit val bsonReader: BSONDocumentReader[Run] = Macros.reader[Run]
//   implicit val bsonWriter: BSONDocumentWriter[Run] = Macros.writer[Run]
// }

