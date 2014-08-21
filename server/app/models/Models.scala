package models

import org.joda.time.DateTime
import play.api.libs.json.{Json, Format}
import reactivemongo.bson.BSONObjectID

import scala.concurrent.Future

case class Race (
  id: BSONObjectID = BSONObjectID.generate,
  startTime: DateTime
)

object Race extends MongoDAO[Race] {
  val collectionName = "races"

  import utils.JsonFormats.idFormat
  implicit val mongoFormat: Format[Race] = Json.format[Race]
}

case class RaceUpdate(now: DateTime, startTime: DateTime, opponents: Seq[BoatState])

case class Point(x: Float, y: Float)

case class BoatState (
  position: Point,
  direction: Float,
  velocity: Float,
  passedGates: Seq[Float]
)

case class BoatUpdate(id: String, state: BoatState)

object JsonFormats {
  import utils.JsonFormats.dateTimeFormat

  implicit val pointFormat: Format[Point] = Json.format[Point]
  implicit val boatStateFormat: Format[BoatState] = Json.format[BoatState]
  implicit val boatUpdateFormat: Format[BoatUpdate] = Json.format[BoatUpdate]
  implicit val raceUpdateFormat: Format[RaceUpdate] = Json.format[RaceUpdate]
}