package dao

import java.util.UUID
import org.joda.time.DateTime
import play.api.libs.json._

import DB.api._
import models._
import models.JsonFormats.courseFormat
import scala.concurrent.Future


object TrackMappings {
  implicit val courseColumn =
    MappedColumnType.base[Course, JsValue](Json.toJson(_), _.as[Course])

  implicit val statusColumn =
    MappedColumnType.base[TrackStatus.Status, String](_.toString, TrackStatus.withName(_))
}

class TrackTable(tag: Tag) extends Table[Track](tag, "tracks") {
  import TrackMappings._

  def id = column[UUID]("id", O.PrimaryKey)
  def name = column[String]("name")
  def creatorId = column[UUID]("creator_id")
  def course = column[Course]("course")
  def status = column[TrackStatus.Status]("status")
  def featured = column[Boolean]("featured")
  def creationTime = column[DateTime]("creation_time")
  def updateTime = column[DateTime]("update_time")

  def * = (id, name, creatorId, course, status, featured, creationTime, updateTime) <> (Track.tupled, Track.unapply)
}

object Tracks extends TableQuery(new TrackTable(_)) {
  import TrackMappings._

  def list(): Future[Seq[Track]] = DB.run {
    all.result
  }

  def findById(id: UUID): Future[Option[Track]] = DB.run {
    onId(id).result.headOption
  }

  def listByCreatorId(id: UUID): Future[Seq[Track]] = DB.run {
    filter(_.creatorId === id).result
  }

  def save(track: Track): Future[Int] = DB.run {
    all += track
  }

  def publish(id: UUID): Future[Int] = DB.run {
    onId(id).map(_.status).update(TrackStatus.open)
  }

  def remove(id: UUID): Future[Int] = DB.run {
    onId(id).delete
  }

  def updateFromEditor(id: UUID, name: String, course: Course): Future[Int] = DB.run {
    onId(id).map(t => (t.name, t.course)).update((name, course))
  }

  private def onId(id: UUID) =
    filter(_.id === id)

  private def all =
    map(identity)
}
