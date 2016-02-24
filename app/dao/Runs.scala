package dao

import java.util.UUID
import scala.concurrent.Future
import org.joda.time.DateTime
import play.api.libs.json._

import DB.api._
import models._
import models.JsonFormats.courseFormat

object RunMappings {
  implicit val tallyColumn =
    MappedColumnType.base[Seq[Long], JsValue](Json.toJson(_), _.as[Seq[Long]])
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

  def listRecent(trackId: UUID, count: Int): Future[Seq[Run]] = DB.run {
    onTrack(trackId).sortBy(_.startTime.desc).take(count).result
  }

  def countForTrack(trackId: UUID): Future[Int] = DB.run {
    onTrack(trackId).countDistinct.result
  }

  def listBestForTrack(trackId: UUID): Future[Seq[Run]] = DB.run {
    onTrack(trackId).sortBy(_.duration.desc).result
  }

  def findBestOnTrackForPlayer(trackId: UUID, playerId: UUID): Future[Seq[Run]] = DB.run {
    onTrack(trackId).filter(_.playerId === playerId).sortBy(_.duration.desc).result
  }

  def extractRankings(trackId: UUID) = DB.run {
    onTrack(trackId)
      .sortBy(_.duration.desc)
      .distinctOn(_.playerId)
      .zipWithIndex
      .map { case (run, i) =>
        (i, run.playerId, run.playerHandle, run.id, run.startTime, run.duration)
      }.result
  }

  def save(run: Run): Future[Int] = DB.run {
    map(identity) += run
  }

  private def onTrack(trackId: UUID) =
    filter(_.trackId === trackId)
}
