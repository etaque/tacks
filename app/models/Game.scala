package models

import org.joda.time.DateTime
import play.api.libs.json._
import play.api.libs.functional.syntax._

object Geo {
  type Point = (Float,Float)
  type Box = (Point,Point)
}

case class Gate(
  y: Float,
  width: Float
)

case class Island(
  location: (Float,Float),
  radius: Float
)

case class Course(
  upwind: Gate,
  downwind: Gate,
  laps: Int,
  markRadius: Float,
  islands: Seq[Island],
  bounds: Geo.Box
)

object Course {
  val default = Course(
    upwind = Gate(1000, 100),
    downwind = Gate(-100, 100),
    laps = 2,
    markRadius = 5,
    islands = Seq(
      Island((250, 300), 100),
      Island((150, 700), 80),
      Island((-200, 500), 60)
    ),
    bounds = ((800,1200), (-800,-400))
  )
}

case class Gust(
  position: Geo.Point,
  radius: Float,
  originDelta: Float
)

case class RaceUpdate(
  now: DateTime,
  startTime: DateTime,
  course: Option[Course],
  opponents: Seq[BoatState] = Seq(),
  gusts: Seq[Gust] = Seq(),
  leaderboard: Seq[String] = Seq()
)

object RaceUpdate {
  def initial(r: Race) = RaceUpdate(
    DateTime.now,
    startTime = r.startTime,
    course = Some(r.course)
  )
}

case class BoatState (
  position: Geo.Point,
  direction: Float,
  velocity: Float,
  passedGates: Seq[Float]
)

case class PlayerUpdate(id: String, state: BoatState)

object JsonFormats {
  import utils.JsonFormats.dateTimeFormat

  implicit val pointFormat: Format[Geo.Point] = utils.JsonFormats.tuple2Format[Float,Float]
  implicit val boxFormat: Format[Geo.Box] = utils.JsonFormats.tuple2Format[Geo.Point,Geo.Point]

  implicit val gustFormat: Format[Gust] = Json.format[Gust]
  implicit val gateFormat: Format[Gate] = Json.format[Gate]
  implicit val islandFormat: Format[Island] = Json.format[Island]
  implicit val courseFormat: Format[Course] = Json.format[Course]
  implicit val boatStateFormat: Format[BoatState] = Json.format[BoatState]
  implicit val playerUpdateFormat: Format[PlayerUpdate] = Json.format[PlayerUpdate]

  implicit val raceUpdateFormat: Format[RaceUpdate] = (
    (__ \ 'now).format[DateTime] and
      (__ \ 'startTime).format[DateTime] and
      (__ \ 'course).format[Option[Course]] and
      (__ \ 'opponents).format[Seq[BoatState]] and
      (__ \ 'gusts).format[Seq[Gust]] and
      (__ \ 'leaderboard).format[Seq[String]]
    )(RaceUpdate.apply, unlift(RaceUpdate.unapply))

}