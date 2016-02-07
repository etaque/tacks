package models

import java.util.UUID
import org.joda.time.DateTime


case class Track(
  id: UUID,
  name: String,
  creatorId: UUID,
  course: Course,
  status: TrackStatus.Value,
  creationTime: DateTime,
  updateTime: DateTime
) {
  val isDraft = status == TrackStatus.draft
  val isOpen = status == TrackStatus.open
}

object TrackStatus extends Enumeration {
  type Status = Value
  val draft, open, archived, deleted = Value
  // implicit val handler = tools.BSONHandlers.enumHandler(TrackStatus)
}
