package models

import org.joda.time.DateTime
import play.api.libs.json.{Json, Format}

case class Race (
  id: String = java.util.UUID.randomUUID.toString,
  startTime: Option[DateTime]
)

case class RaceUpdate(now: DateTime, startTime: Option[DateTime], opponents: Seq[BoatState])

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
  implicit val raceFormat: Format[Race] = Json.format[Race]
  implicit val raceUpdateFormat: Format[RaceUpdate] = Json.format[RaceUpdate]
}