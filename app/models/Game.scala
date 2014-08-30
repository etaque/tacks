package models

import org.joda.time.DateTime
import play.api.libs.json._
import play.api.libs.functional.syntax._

object Geo {
  type Point = (Float,Float) // (x,y)
  type Box = (Point,Point) // ((right,top),(left,bottom))

  def distanceBetween(p1: Point, p2: Point): Double = {
    val (x1,y1) = p1
    val (x2,y2) = p2
    Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2))
  }

  def inBox(p: Point, b: Box): Boolean = {
    val (x,y) = p
    val ((right, top), (left, bottom)) = b
    x > left && x < right && y > bottom && y < top
  }

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
  def randomPoint: Geo.Point = (randomX(0), randomY(0))
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
    bounds = ((800,1200), (-800,-400))
  )
}

case class Gust(
  position: Geo.Point,
  angle: Float, // degrees
  speed: Float,
  radius: Float
) {
  val radians = (90 - angle) * Math.PI / 180
  val pixelSpeed = speed * 0.005
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

case class Spell(
  kind: String,
  duration: Int // seconds
)

case class Buoy(
  position: Geo.Point,
  radius: Float,
  spell: Spell
)

object Buoy {
  import scala.util.Random._
  def spawn: Buoy = Buoy(
      position = (nextInt(1600) - 800, nextInt(1600) - 400),
      radius = 5,
      spell = Spell(
        kind = nextInt(2) match {
          case 0 => "PoleInversion"
          case _ => "Fog"
        },
        duration = 20))

  val default = Seq()
}

case class RaceUpdate(
  now: DateTime,
  startTime: DateTime,
  course: Option[Course],
  opponents: Seq[BoatState] = Seq(),
  gusts: Seq[Gust] = Seq(),
  buoys: Seq[Buoy] = Seq(),
  playerSpell: Option[Spell] = None,
  triggeredSpells: Seq[Spell] = Seq(),
  leaderboard: Seq[String] = Seq()
)

object RaceUpdate {
  def initial(r: Race) = RaceUpdate(
    DateTime.now,
    startTime = r.startTime,
    course = Some(r.course)
  )
}

case class BoatInput (
  name: String,
  position: Geo.Point,
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
  position: Geo.Point,
  direction: Float,
  velocity: Float,
  passedGates: Seq[Float],
  ownSpell: Option[Spell] = None,
  triggeredSpells: Seq[Spell] = Seq()
) {

  def collisions(buoys: Seq[Buoy]): Option[Buoy] = buoys.find { buoy =>
    Geo.distanceBetween(buoy.position, position) <= buoy.radius
  }

  def withSpell(spell: Spell) = copy(ownSpell = Some(spell))
}

case class PlayerUpdate(id: String, input: BoatInput)

object JsonFormats {
  import utils.JsonFormats.dateTimeFormat

  implicit val pointFormat: Format[Geo.Point] = utils.JsonFormats.tuple2Format[Float,Float]
  implicit val boxFormat: Format[Geo.Box] = utils.JsonFormats.tuple2Format[Geo.Point,Geo.Point]

  implicit val spellFormat: Format[Spell] = Json.format[Spell]
  implicit val buoyFormat: Format[Buoy] = Json.format[Buoy]
  implicit val gustFormat: Format[Gust] = Json.format[Gust]
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
      (__ \ 'opponents).format[Seq[BoatState]] and
      (__ \ 'gusts).format[Seq[Gust]] and
      (__ \ 'buoys).format[Seq[Buoy]] and
      (__ \ 'playerSpell).format[Option[Spell]] and
      (__ \ 'triggeredSpells).format[Seq[Spell]] and
      (__ \ 'leaderboard).format[Seq[String]]
    )(RaceUpdate.apply, unlift(RaceUpdate.unapply))

}
