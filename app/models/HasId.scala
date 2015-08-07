package models

import org.joda.time.DateTime
import reactivemongo.bson.BSONObjectID

trait HasId {
  def _id: BSONObjectID
  val id: BSONObjectID = _id
  def idToStr = id.stringify

  def idTime = new DateTime(id.time)
}
