package models

import org.joda.time.DateTime
import play.api.libs.json.{Json, Format}
import reactivemongo.bson.BSONObjectID

case class Race (
  id: BSONObjectID = BSONObjectID.generate,
  startTime: DateTime,
  leaderboard: Seq[String] = Seq()
) {
  def initialUpdate = RaceUpdate(
    DateTime.now,
    startTime
  )
}

object Race extends MongoDAO[Race] {
  val collectionName = "races"

  import utils.JsonFormats.idFormat
  implicit val mongoFormat: Format[Race] = Json.format[Race]
}

case class Point(x: Float, y: Float)

sealed trait GateLocation
case object Upwind extends GateLocation
case object Downwind extends GateLocation

case class Gate(
  y: Float,
  width: Float,
  location: GateLocation
)

case class Island(
  location: Point,
  radius: Float
)

case class Course(
  upwind: Gate,
  downwind: Gate,
  laps: Int,
  markRadius: Float,
  islands: Seq[Island],
  bounds: (Point, Point)
)

case class RaceUpdate(
  now: DateTime,
  startTime: DateTime,
  opponents: Seq[BoatState] = Seq(),
  leaderboard: Seq[String] = Seq()
)

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