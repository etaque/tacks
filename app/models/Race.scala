package models

import org.joda.time.DateTime
import play.api.libs.json._
import reactivemongo.bson.BSONObjectID

case class Race (
  _id: BSONObjectID = BSONObjectID.generate,
  startTime: DateTime,
  course: Course = Course.default,
  leaderboard: Seq[String] = Seq()
) extends HasId {

  def initialUpdate = RaceUpdate(
    DateTime.now,
    startTime = startTime,
    course = course
  )

  def millisBeforeStart = startTime.getMillis - DateTime.now.getMillis
}

object Race extends MongoDAO[Race] {
  val collectionName = "races"

  import utils.JsonFormats.idFormat
  import JsonFormats._
  implicit val mongoFormat: Format[Race] = Json.format[Race]
}
