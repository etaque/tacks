package models

import scala.util.Random
import scala.util.Try
import java.lang.Math._

import org.joda.time.DateTime
import reactivemongo.bson._
import play.api.libs.json.Format

import models.Geo._
import tools.BSONHandlers._

case class Course(
  upwind: Gate,
  downwind: Gate,
  laps: Int,
  grid: Course.Grid = Nil,
  area: RaceArea,
  windSpeed: Int,
  windGenerator: WindGenerator,
  gustGenerator: GustGenerator
)

object Course {
  def spawn = {
    Course(
      upwind = Gate(800, 200),
      downwind = Gate(0, 200),
      laps = 2,
      grid = Nil,
      area = RaceArea((0, 0), (0, 0)),
      windSpeed = 15,
      windGenerator = WindGenerator.spawn(),
      gustGenerator = GustGenerator.default
    )
  }

  type Grid = Seq[(Int, GridRow)]
  type GridRow = Seq[(Int, String)]

  implicit val gridRowTupleHandler = tupleHandler[Int, BSONInteger, String, BSONString]
  implicit val gridRowHandler = seqHandler[(Int, String), BSONArray]
  implicit val gridTupleHandler = tupleHandler[Int, BSONInteger, GridRow, BSONArray]
  implicit val gridHandler = seqHandler[(Int, GridRow), BSONArray]

  implicit val raceAreaHandler = Macros.handler[RaceArea]
  implicit val gustSpecHandler = Macros.handler[GustDef]
  implicit val gustGeneratorHandler = Macros.handler[GustGenerator]
  implicit val windGeneratorHandler = Macros.handler[WindGenerator]
  implicit val gateHandler = Macros.handler[Gate]
  implicit val courseHandler = Macros.handler[Course]
}

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

  def genX(seed: Double, margin: Double): Double = {
    val effectiveWidth = width - margin * 2
    seed % effectiveWidth - effectiveWidth / 2 + cx
  }
  def genY(seed: Double, margin: Double): Double = {
    val effectiveHeight = height - margin * 2
    seed % effectiveHeight - effectiveHeight / 2 + cy
  }
}

case class Gate(
  y: Double,
  width: Double
)

case class WindGenerator(
  wavelength1: Int,
  amplitude1: Int,
  wavelength2: Int,
  amplitude2: Int
) {
  def windOrigin(clock: Long): Double =
    cos(clock * 0.0005 / wavelength1) * amplitude1 + cos(clock * 0.0005 / wavelength2) * amplitude2

  def windSpeed(clock: Long): Double = Wind.defaultWindSpeed +
    (cos(clock * 0.0005 / wavelength1) * 4 - cos(clock * 0.0005 / wavelength2) * 5) * 0.5
}

object WindGenerator {
  def spawn(w1: Int = 6, a1: Int = 6, w2: Int = 4, a2: Int = 4) = {
    WindGenerator(Random.nextInt(w1) + w1, Random.nextInt(a1) + a1, Random.nextInt(w2) + w2, Random.nextInt(a2) + a2)
  }
  val empty = WindGenerator(0, 1, 0, 1)
}

case class GustGenerator(
  interval: Int,
  radiusBase: Int,
  radiusVariation: Int,
  speedVariation: Range,
  originVariation: Range
) {
  def generateSpeed() = Random.shuffle(speedVariation.toList).headOption.getOrElse(0)
  def generateOrigin() = Random.shuffle(originVariation.toList).headOption.getOrElse(0)
  def generateRadius() = min(radiusBase + Random.nextInt(radiusVariation) - radiusVariation / 2, GustGenerator.minRadius)
}

object GustGenerator {
  val minRadius = 50
  val default = GustGenerator(
    interval = 20,
    radiusBase = 250,
    radiusVariation = 100,
    speedVariation = Range(-5, 5),
    originVariation = Range(-10, 10)
  )
}

case class GustDef(
  angle: Double,
  speed: Double,
  radius: Double
)
