package models

import java.lang.Math._

import models.Geo._
import org.joda.time.DateTime
import play.api.libs.json.{Json, Format}

sealed trait GateLocation
case object StartLine extends GateLocation
case object UpwindGate extends GateLocation
case object DownwindGate extends GateLocation

case class Gate(
  y: Double,
  width: Double
) {

  def crossedInX(s: Segment) = {
    val ((x1,y1),(x2,y2)) = s
    val a = (y1 - y2) / (x1 - x2)
    val b = y1 - a * x1
    val xGate = (y - b) / a
    abs(xGate) <= width / 2
  }

  def crossedDownward(s: Segment) = {
    val ((_,y1),(_,y2)) = s
    y1 > y && y2 <= y && crossedInX(s)
  }

  def crossedUpward(s: Segment) = {
    val ((_,y1),(_,y2)) = s
    y1 < y && y2 >= y && crossedInX(s)
  }

  def segment: Segment = ((-width / 2, y), (width / 2, y))
}

case class Island(
  location: (Double,Double),
  radius: Double
)

case class WindGenerator(
  wavelength1: Int,
  amplitude1: Int,
  wavelength2: Int,
  amplitude2: Int
) {
  def windOrigin(at: DateTime): Double =
    cos(at.getMillis * 0.001 / wavelength1) * amplitude1 + cos(at.getMillis * 0.001 / wavelength2) * amplitude2

  def windSpeed(at: DateTime): Double = Wind.defaultWindSpeed +
    (cos(at.getMillis * 0.001 / wavelength1) * 5 - cos(at.getMillis * 0.001 / wavelength2) * 5) / 2
}


case class Course(
  upwind: Gate,
  downwind: Gate,
  laps: Int,
  markRadius: Double,
  islands: Seq[Island],
  bounds: Box,
  windGenerator: WindGenerator,
  gustsCount: Int,
  windShadowLength: Double,
  boatWidth: Double // for collision detection, should be consistent with icon
) {
  lazy val ((right, top), (left, bottom)) = bounds

  lazy val width = abs(right - left)
  lazy val height = abs(top - bottom)

  lazy val cx = (right + left) / 2
  lazy val cy = (top + bottom) / 2
  lazy val center = (cx, cy)

  import scala.util.Random._

  def randomX(margin: Double = 0): Double = nextDouble * (width - margin * 2) - width / 2 + margin + cx
  def randomY(margin: Double = 0): Double = nextDouble * (height - margin * 2) - height / 2 + margin + cy
  def randomPoint: Point = (randomX(0), randomY(0))

  def nextGate(crossedGates: Int): Option[GateLocation] = {
    val m = crossedGates % 2
    if (crossedGates == laps * 2 + 1) None // finished
    else if (crossedGates == 0) Some(StartLine)
    else if (m == 0) Some(DownwindGate)
    else Some(UpwindGate)
  }
}

object Course {
  val default = Course(
    upwind = Gate(2000, 150),
    downwind = Gate(-100, 150),
    laps = 2,
    markRadius = 5,
    islands = Seq(
      Island((-250, 300), 90),
      Island((150, 900), 80),
      Island((-200, 1200), 60)
    ),
    bounds = ((800,2200), (-800,-400)),
    windGenerator = WindGenerator(8, 10, 5, 5),
    gustsCount = 8,
    windShadowLength = 120,
    boatWidth = 8
  )


  implicit val windGeneratorFormat: Format[WindGenerator] = Json.format[WindGenerator]
  implicit val gateFormat: Format[Gate] = Json.format[Gate]
  implicit val islandFormat: Format[Island] = Json.format[Island]
  implicit val courseFormat: Format[Course] = Json.format[Course]
}
