package models

import org.joda.time.{LocalDate, DateTime}
import reactivemongo.bson._

case class Track(
  _id: BSONObjectID,
  name: String,
  draft: Boolean,
  creatorId: BSONObjectID,
  course: Course
) extends HasId


