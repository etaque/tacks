package models

import org.joda.time.DateTime
import play.api.libs.json._
import reactivemongo.bson.BSONObjectID

case class Race (
  _id: BSONObjectID = BSONObjectID.generate,
  userId: BSONObjectID,
  isPrivate: Boolean,
  course: Course,
  countdownSeconds: Int
) extends HasId

object Race extends MongoDAO[Race] {
  val collectionName = "races"

  import utils.JsonFormats.idFormat
  import JsonFormats._
  implicit val mongoFormat: Format[Race] = Json.format[Race]
}
