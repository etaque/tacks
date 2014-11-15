package models

import scala.util.Random.nextInt
import java.lang.Math._
import org.joda.time.DateTime
import reactivemongo.bson.Macros

import models.Geo._

sealed trait GateLocation
case object StartLine extends GateLocation
case object UpwindGate extends GateLocation
case object DownwindGate extends GateLocation

case class RaceArea(rightTop: Point, leftBottom: Point) {
  lazy val ((right, top), (left, bottom)) = (rightTop, leftBottom)

  lazy val width = abs(right - left)
  lazy val height = abs(top - bottom)

  lazy val cx = (right + left) / 2
  lazy val cy = (top + bottom) / 2
  lazy val center = (cx, cy)

  def genX(seed: Double, margin: Double = 0): Double = seed * (width - margin * 2) - width / 2 + margin + cx
  def genY(seed: Double, margin: Double = 0): Double = seed * (height - margin * 2) - height / 2 + margin + cy

  import scala.util.Random._

  def randomX(margin: Double = 0): Double = genX(nextDouble(), margin)
  def randomY(margin: Double = 0): Double = genY(nextDouble(), margin)
  def randomPoint: Point = (randomX(0), randomY(0))

  def toBox = (rightTop, leftBottom)
}

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

object Island {
  def spawn(area: RaceArea): Island = {
    Island((area.randomX(200), area.randomY(400)), nextInt(50) + 50)
  }
}

case class WindGenerator(
  wavelength1: Int,
  amplitude1: Int,
  wavelength2: Int,
  amplitude2: Int
) {
  def windOrigin(clock: Long): Double =
    cos(clock * 0.0005 / wavelength1) * amplitude1 + cos(clock * 0.0005 / wavelength2) * amplitude2

  def windSpeed(clock: Long): Double = Wind.defaultWindSpeed +
    (cos(clock * 0.0005 / wavelength1) * 5 - cos(clock * 0.0005 / wavelength2) * 5) * 0.5
}

object WindGenerator {
  def spawn = {
    WindGenerator(nextInt(6) + 6, nextInt(6) + 6, nextInt(4) + 4, nextInt(4) + 4)
  }
}


case class Course(
  upwind: Gate,
  downwind: Gate,
  laps: Int,
  markRadius: Double,
  islands: Seq[Island],
  area: RaceArea,
  windGenerator: WindGenerator,
  gustsCount: Int,
  windShadowLength: Double,
  boatWidth: Double // for collision detection, should be consistent with icon
) {
  def gatesToCross = laps * 2 + 1

  def nextGate(crossedGates: Int): Option[GateLocation] = {
    if (crossedGates == gatesToCross) None // finished
    else if (crossedGates == 0) Some(StartLine)
    else if (crossedGates % 2 == 0) Some(DownwindGate)
    else Some(UpwindGate)
  }
}

object Course {
  val defaultRaceArea = RaceArea((800,3200), (-800,-200))

  def spawn = Course(
    upwind = Gate(3000, 200),
    downwind = Gate(100, 200),
    laps = 2,
    markRadius = 5,
    islands = Seq.fill[Island](8)(Island.spawn(defaultRaceArea)),
    area = defaultRaceArea,
    windGenerator = WindGenerator.spawn,
    gustsCount = 6,
    windShadowLength = 120,
    boatWidth = 4
  )

  implicit val raceAreaHandler = Macros.handler[RaceArea]
  implicit val windGeneratorHandler = Macros.handler[WindGenerator]
  implicit val gateHandler = Macros.handler[Gate]
  implicit val islandHandler = Macros.handler[Island]
  implicit val courseHandler = Macros.handler[Course]

}
