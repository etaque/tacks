package dao

import java.util.UUID
import org.joda.time.DateTime
import play.api.libs.json._
import DB.api._
import models._
import scala.concurrent.Future


class TimeTrialTable(tag: Tag) extends Table[TimeTrial](tag, "time_trials") {
  def id = column[UUID]("id", O.PrimaryKey)
  def trackId = column[UUID]("track_id")
  def period = column[String]("period")
  def creationTime = column[DateTime]("creation_time")

  def * = (id, trackId, period, creationTime) <> ((TimeTrial.apply _).tupled, TimeTrial.unapply)
}

object TimeTrials extends TableQuery(new TimeTrialTable(_)) {

  def list(): Future[Seq[TimeTrial]] = DB.run {
    all.sortBy(_.creationTime.desc).result
  }

  def findById(id: UUID): Future[Option[TimeTrial]] = DB.run {
    onId(id).result.headOption
  }

  def findByPeriod(period: String): Future[Option[TimeTrial]] = DB.run {
    filter(_.period === period).result.headOption
  }

  def findByPeriodWithTrack(period: String): Future[Option[(TimeTrial, Track)]] = DB.run {
    filter(_.period === period).join(Tracks).on(_.trackId === _.id).result.headOption
  }

  def save(timeTrial: TimeTrial): Future[Int] = DB.run {
    all += timeTrial
  }

  def remove(id: UUID): Future[Int] = DB.run {
    onId(id).delete
  }

  private def onId(id: UUID) =
    filter(_.id === id)

  private def all =
    map(identity)
}
