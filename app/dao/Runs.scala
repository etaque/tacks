package dao

import java.util.UUID
import scala.concurrent.Future
import org.joda.time.DateTime
import play.api.libs.json._
import slick.jdbc.GetResult

import DB.api._
import models._
import models.JsonFormats.courseFormat

object RunMappings {
  implicit val tallyColumn =
    MappedColumnType.base[Seq[Long], JsValue](Json.toJson(_), _.as[Seq[Long]])

  implicit val getRankings =
    GetResult(r => RunRanking(r.nextLong, r.nextUUID, r.nextUUID, r.nextLong))

  implicit val getRaceIds =
    GetResult(_.nextUUID)
}

class RunTable(tag: Tag) extends Table[Run](tag, "runs") {
  import RunMappings._

  def id = column[UUID]("id", O.PrimaryKey)
  def trackId = column[UUID]("track_id")
  def raceId = column[UUID]("race_id")
  def playerId = column[UUID]("player_id")
  def playerHandle = column[Option[String]]("player_handle")
  def startTime = column[DateTime]("start_time")
  def tally = column[Seq[Long]]("tally")
  def duration = column[Long]("duration")

  def * = (id, trackId, raceId, playerId, playerHandle, startTime, tally, duration) <> (Run.tupled, Run.unapply)
}

object Runs extends TableQuery(new RunTable(_)) {
  import RunMappings._

  def findById(id: UUID): Future[Option[Run]] = DB.run {
    onId(id).result.headOption
  }

  def listRecent(trackId: UUID, count: Int): Future[Seq[Run]] = DB.run {
    onTrack(trackId).sortBy(_.startTime.desc).take(count).result
  }

  def countForTrack(trackId: UUID): Future[Int] = DB.run {
    onTrack(trackId).countDistinct.result
  }

  def listBestOnTrackForPlayer(trackId: UUID, playerId: UUID): Future[Seq[Run]] = DB.run {
    onTrack(trackId).filter(_.playerId === playerId).sortBy(_.duration.asc).result
  }

  def extractRankings(trackId: UUID) = DB.run {
    sql"""
      SELECT row_number() OVER (order by duration), r.id, player_id, duration FROM (
        SELECT DISTINCT ON (player_id) * FROM runs
        WHERE track_id = $trackId
        ORDER BY player_id, duration
      ) AS r
      JOIN users ON users.id = player_id
      ORDER BY duration ASC
    """.as[RunRanking]
  }


  def lastRaceIds(limit: Int, minPlayers: Option[Int], trackId: Option[UUID]): Future[Seq[UUID]] = DB.run {
    val whereTrack = trackId.map(id => s"WHERE track_id = '$id'").getOrElse("")
    sql"""
      SELECT race_id, min(start_time) as t FROM runs #$whereTrack
      GROUP BY race_id
      HAVING COUNT(player_id) >= ${minPlayers.getOrElse(2)}
      ORDER BY t DESC LIMIT $limit
    """.as[UUID]
  }

  // def lastRaceIds(limit: Int, minPlayers: Option[Int], trackId: Option[UUID]): Future[Seq[UUID]] = DB.run {
  //   val q = trackId.map(onTrack).getOrElse(all)
  //     .sortBy(r => (r.startTime.desc, r.duration.asc))
  //     .groupBy(_.raceId)
  //     .map { case (raceId, group) => (raceId, group.size) }
  //     .filter(_._2 >= minPlayers.getOrElse(2))
  //     .map(_._1)
  //     .take(limit)
  //   println(q.result.statements)
  //     q.result
  // }

  def listForRaces(raceIds: Seq[UUID]): Future[Seq[Run]] = DB.run {
    filter(_.raceId.inSet(raceIds)).result
  }

  def save(run: Run): Future[Int] = DB.run {
    all += run
  }

  private def onId(id: UUID) =
    filter(_.id === id)

  private def onTrack(trackId: UUID) =
    filter(_.trackId === trackId)

  private def all =
    map(identity)
}
