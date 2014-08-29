package models

import org.joda.time.DateTime
import play.api.libs.json._
import reactivemongo.bson.BSONObjectID

case class Race (
  _id: BSONObjectID = BSONObjectID.generate,
  startTime: DateTime,
  course: Course,
  leaderboard: Seq[String] = Seq()
) extends HasId {

  def millisBeforeStart = startTime.getMillis - DateTime.now.getMillis

  def started = millisBeforeStart <= 0
}

object Race extends MongoDAO[Race] {
  val collectionName = "races"

  import utils.JsonFormats.idFormat
  import JsonFormats._
  implicit val mongoFormat: Format[Race] = Json.format[Race]
}
