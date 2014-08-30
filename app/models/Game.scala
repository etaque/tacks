package models

import org.joda.time.DateTime
import play.api.libs.json._
import play.api.libs.functional.syntax._

import Geo._

case class Gate(
  y: Float,
  width: Float
)

case class Island(
  location: (Float,Float),
  radius: Float
)

case class WindGenerator(
  wavelength1: Int,
  amplitude1: Int,
  wavelength2: Int,
  amplitude2: Int
) {
  def windOrigin(at: DateTime) =
    Math.cos(at.getMillis * 0.001 / wavelength1) * amplitude1 + Math.cos(at.getMillis * 0.001 / wavelength2) * amplitude2
}

case class Course(
  upwind: Gate,
  downwind: Gate,
  laps: Int,
  markRadius: Float,
  islands: Seq[Island],
  bounds: Box,
  windGenerator: WindGenerator
) {
  lazy val ((right, top), (left, bottom)) = bounds
  
  lazy val width = Math.abs(right - left)
  lazy val height = Math.abs(top - bottom)

  lazy val cx = (right + left) / 2
  lazy val cy = (top + bottom) / 2
  lazy val center = (cx, cy)

  import scala.util.Random._

  def randomX(margin: Int = 0): Float = nextInt(width.toInt - margin * 2) - width / 2 + margin + cx
  def randomY(margin: Int = 0): Float = nextInt(height.toInt - margin * 2) - height / 2 + margin + cy
  def randomPoint: Point = (randomX(0), randomY(0))
}

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
    bounds = ((800,1200), (-800,-400)),
    windGenerator = WindGenerator(8, 10, 5, 5)
  )
}

case class Gust(
  position: Point,
  angle: Float, // degrees
  speed: Float,
  radius: Float
) {
  val radians = (90 - angle) * Math.PI / 180
  val pixelSpeed = speed * 0.005 // on milliseconds
}

object Gust {
  import scala.util.Random._

  def default(course: Course, quantity: Int = 5) = Seq.fill(quantity)(spawn(course, initial = true))

  def spawn(course: Course, initial: Boolean) = Gust(
    position = (course.randomX(100), if (initial) course.randomY(0) else course.top),
    angle = nextInt(30) - 15,
    speed = nextInt(5) + 5,
    radius = nextInt(50) + 100
  )
}

case class Wind(
  origin: Double,
  speed: Double,
  gusts: Seq[Gust]
)

object Wind {
  val default = Wind(0, 10, Nil)
}

case class Spell(
  kind: String,
  duration: Int // seconds
)

case class Buoy(
  position: Point,
  radius: Float,
  spell: Spell
)

object Buoy {
  import scala.util.Random._
  def spawn(course: Course) = Buoy(
    position = course.randomPoint,
    radius = 5,
    spell = Spell(
      kind = nextInt(2) match {
        case 0 => "PoleInversion"
        case _ => "Fog"
      },
      duration = 10))
}

case class RaceUpdate(
  now: DateTime,
  startTime: DateTime,
  course: Option[Course],
  wind: Wind,
  opponents: Seq[BoatState] = Seq(),
  buoys: Seq[Buoy] = Seq(),
  playerSpell: Option[Spell] = None,
  triggeredSpells: Seq[Spell] = Seq(),
  leaderboard: Seq[String] = Seq()
)

object RaceUpdate {
  def initial(r: Race) = RaceUpdate(
    DateTime.now,
    startTime = r.startTime,
    course = Some(r.course),
    wind = Wind.default
  )
}

case class BoatInput (
  name: String,
  position: Point,
  direction: Float,
  velocity: Float,
  passedGates: Seq[Float],
  spellCast: Boolean) {

  def makeState = BoatState(name, position, direction, velocity, passedGates, None, Seq())

  def updateState(state: BoatState) = state.copy(
    position = position,
    direction = direction,
    velocity = velocity,
    passedGates = passedGates)
}

case class BoatState (
  name: String,
  position: Point,
  direction: Float,
  velocity: Float,
  passedGates: Seq[Float],
  ownSpell: Option[Spell] = None,
  triggeredSpells: Seq[Spell] = Seq()
) {

  def collision(buoys: Seq[Buoy]): Option[Buoy] = buoys.find { buoy =>
    distanceBetween(buoy.position, position) <= buoy.radius
  }

  def withSpell(spell: Spell) = copy(ownSpell = Some(spell))
}

case class PlayerUpdate(id: String, input: BoatInput)

object JsonFormats {
  import utils.JsonFormats.dateTimeFormat

  implicit val spellFormat: Format[Spell] = Json.format[Spell]
  implicit val buoyFormat: Format[Buoy] = Json.format[Buoy]
  implicit val gustFormat: Format[Gust] = Json.format[Gust]
  implicit val windGeneratorFormat: Format[WindGenerator] = Json.format[WindGenerator]
  implicit val windFormat: Format[Wind] = Json.format[Wind]
  implicit val gateFormat: Format[Gate] = Json.format[Gate]
  implicit val islandFormat: Format[Island] = Json.format[Island]
  implicit val courseFormat: Format[Course] = Json.format[Course]
  implicit val boatStateFormat: Format[BoatState] = Json.format[BoatState]
  implicit val boatInputFormat: Format[BoatInput] = Json.format[BoatInput]
  implicit val playerUpdateFormat: Format[PlayerUpdate] = Json.format[PlayerUpdate]

  implicit val raceUpdateFormat: Format[RaceUpdate] = (
    (__ \ 'now).format[DateTime] and
      (__ \ 'startTime).format[DateTime] and
      (__ \ 'course).format[Option[Course]] and
      (__ \ 'wind).format[Wind] and
      (__ \ 'opponents).format[Seq[BoatState]] and
      (__ \ 'buoys).format[Seq[Buoy]] and
      (__ \ 'playerSpell).format[Option[Spell]] and
      (__ \ 'triggeredSpells).format[Seq[Spell]] and
      (__ \ 'leaderboard).format[Seq[String]]
    )(RaceUpdate.apply, unlift(RaceUpdate.unapply))

}
