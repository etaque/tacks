package models

import scala.util.Try

import org.joda.time.{LocalDate, DateTime}
import reactivemongo.bson._

case class Track(
  _id: BSONObjectID,
  name: String,
  creatorId: BSONObjectID,
  course: Course,
  status: TrackStatus.Value
) extends HasId {
  val isDraft = status == TrackStatus.draft
  val isOpen = status == TrackStatus.open
}

object TrackStatus extends Enumeration {
  type Status = Value
  val draft, open, archived, deleted = Value

  implicit val handler = tools.BSONHandlers.enumHandler(TrackStatus)
}
