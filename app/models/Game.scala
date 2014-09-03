package models

import Math._
import org.joda.time.DateTime
import play.api.data.validation.ValidationError
import play.api.libs.json._
import play.api.libs.functional.syntax._

import Geo._

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
    boatWidth = 9
  )
}

case class Gust(
  position: Point,
  angle: Double, // degrees
  speed: Double,
  radius: Double,
  maxRadius: Double,
  spawnedAt: DateTime
) {
  val radians = angleToRadians(angle)
  val pixelPerSecond = 1
  val maxRadiusAfterSeconds = 20

  def update(course: Course, wind: Wind, lastUpdate: DateTime, now: DateTime): Gust = {
    val delta = now.getMillis - lastUpdate.getMillis
    val groundSpeed = (wind.speed + speed) * pixelPerSecond * 0.001
    val groundDirection = ensure360(angle + 180)
    val newPosition = movePoint(position, delta, groundSpeed, groundDirection)
    val radius = min((now.getMillis - spawnedAt.getMillis) * 0.001 * maxRadius / maxRadiusAfterSeconds, maxRadius)
    copy(position = newPosition, radius = radius)
  }
}

object Gust {
  import scala.util.Random._

  def spawnAll(course: Course) = Seq.fill(course.gustsCount)(spawn(course))

  def spawn(course: Course) = Gust(
    position = (course.randomX(), course.top),
    angle = nextInt(30) - 15,
    speed = nextInt(15) - 5,
    radius = 0,
    maxRadius = nextInt(50) + 200,
    spawnedAt = DateTime.now
  )
}

case class Wind(
  origin: Double,
  speed: Double,
  gusts: Seq[Gust]
)

object Wind {
  val defaultWindSpeed = 15
  val default = Wind(0, defaultWindSpeed, Nil)
}

case class Spell(
  kind: String,
  duration: Int // seconds
)

case class Buoy(
  position: Point,
  radius: Double,
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
  startTime: Option[DateTime],
  course: Option[Course],
  crossedGates: Seq[DateTime],
  nextGate: Option[GateLocation],
  wind: Wind,
  opponents: Seq[PlayerState] = Seq(),
  buoys: Seq[Buoy] = Seq(),
  playerSpell: Option[Spell] = None,
  triggeredSpells: Seq[Spell] = Seq(),
  leaderboard: Seq[String] = Seq(),
  isMaster: Boolean = false
)

object RaceUpdate {
  def initial(r: Race) = RaceUpdate(
    DateTime.now,
    startTime = None,
    course = Some(r.course),
    crossedGates = Nil,
    nextGate = Some(StartLine),
    wind = Wind.default
  )
}

case class PlayerInput (
  name: String,
  position: Point,
  direction: Double,
  velocity: Double,
  spellCast: Boolean,
  startCountdown: Boolean) {

  def makeState = PlayerState(DateTime.now, name, position, direction, velocity, Seq(), Some(StartLine), None, Seq())

  def updateState(state: PlayerState) = state.copy(
    at = DateTime.now,
    position = position,
    direction = direction,
    velocity = velocity)
}

case class PlayerState (
  at: DateTime,
  name: String,
  position: Point,
  direction: Double,
  velocity: Double,
  crossedGates: Seq[DateTime],
  nextGate: Option[GateLocation],
  ownSpell: Option[Spell] = None,
  triggeredSpells: Seq[Spell] = Seq()
) {

  def collision(boatWidth: Double, buoys: Seq[Buoy]): Option[Buoy] = buoys.find { buoy =>
    distanceBetween(buoy.position, position) <= buoy.radius + boatWidth / 2
  }

  def withSpell(spell: Spell) = copy(ownSpell = Some(spell))
  
  def updateCrossedGates(course: Course, started: Boolean)(previousState: PlayerState): PlayerState = {
    val now = DateTime.now
    val step = (previousState.position, position)
    val nextGate = course.nextGate(crossedGates.size)
    val newPassedGates = nextGate match {
      case Some(StartLine) => {
        if (started && course.downwind.crossedUpward(step)) now +: crossedGates
        else crossedGates
      }
      case Some(UpwindGate) => {
        if (course.upwind.crossedUpward(step)) now +: crossedGates
        else if (course.downwind.crossedUpward(step)) crossedGates.tail
        else crossedGates

      }
      case Some(DownwindGate) => {
        if (course.downwind.crossedDownward(step)) now +: crossedGates
        else if (course.upwind.crossedDownward(step)) crossedGates.tail
        else crossedGates
      }
      case None => crossedGates // already finished race
    }
    copy(crossedGates = newPassedGates, nextGate = nextGate)
  }
}

case class PlayerUpdate(id: String, input: PlayerInput)

object JsonFormats {
  import utils.JsonFormats.dateTimeFormat

  implicit val gateLocationFormat: Format[GateLocation] = new Format[GateLocation] {
    override def reads(json: JsValue): JsResult[GateLocation] = json match {
      case JsString("StartLine") => JsSuccess(StartLine)
      case JsString("DownwindGate") => JsSuccess(DownwindGate)
      case JsString("UpwindGate") => JsSuccess(UpwindGate)
      case _ @ v => JsError(Seq(JsPath() -> Seq(ValidationError("Expected GateLocation value, got: " + v.toString))))
    }
    override def writes(o: GateLocation): JsValue = JsString(o match {
      case StartLine => "StartLine"
      case DownwindGate => "DownwindGate"
      case UpwindGate => "UpwindGate"
    })
  }

  implicit val spellFormat: Format[Spell] = Json.format[Spell]
  implicit val buoyFormat: Format[Buoy] = Json.format[Buoy]
  implicit val gustFormat: Format[Gust] = Json.format[Gust]
  implicit val windGeneratorFormat: Format[WindGenerator] = Json.format[WindGenerator]
  implicit val windFormat: Format[Wind] = Json.format[Wind]
  implicit val gateFormat: Format[Gate] = Json.format[Gate]
  implicit val islandFormat: Format[Island] = Json.format[Island]
  implicit val courseFormat: Format[Course] = Json.format[Course]
  implicit val playerStateFormat: Format[PlayerState] = Json.format[PlayerState]
  implicit val playerInputFormat: Format[PlayerInput] = Json.format[PlayerInput]
  implicit val playerUpdateFormat: Format[PlayerUpdate] = Json.format[PlayerUpdate]

  implicit val raceUpdateFormat: Format[RaceUpdate] = (
    (__ \ 'now).format[DateTime] and
      (__ \ 'startTime).format[Option[DateTime]] and
      (__ \ 'course).format[Option[Course]] and
      (__ \ 'crossedGates).format[Seq[DateTime]] and
      (__ \ 'nextGate).format[Option[GateLocation]] and
      (__ \ 'wind).format[Wind] and
      (__ \ 'opponents).format[Seq[PlayerState]] and
      (__ \ 'buoys).format[Seq[Buoy]] and
      (__ \ 'playerSpell).format[Option[Spell]] and
      (__ \ 'triggeredSpells).format[Seq[Spell]] and
      (__ \ 'leaderboard).format[Seq[String]] and
      (__ \ 'isMaster).format[Boolean]
    )(RaceUpdate.apply, unlift(RaceUpdate.unapply))

}
