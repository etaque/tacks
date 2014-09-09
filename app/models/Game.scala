package models

import Math._
import org.joda.time.DateTime
import play.api.data.validation.ValidationError
import play.api.libs.json._
import play.api.libs.functional.syntax._

import Geo._

case class Arrows(x: Int, y: Int)

case class PlayerInput (
  name: String,
  tack: Boolean,
  arrows: Arrows,
  subtleTurn: Boolean,
  lock: Boolean,
  spellCast: Boolean,
  startCountdown: Boolean)

sealed trait ControlMode
case object FixedHeading extends ControlMode
case object FixedAngle extends ControlMode

case class PlayerState (
  name: String,
  position: Point,
  heading: Double,
  velocity: Double,
  windAngle: Double,
  windOrigin: Double,
  windSpeed: Double,
  upwindVmg: Double,
  downwindVmg: Double,
  controlMode: ControlMode,
  tackTarget: Option[Double],
  crossedGates: Seq[DateTime],
  nextGate: Option[GateLocation],
  ownSpell: Option[Spell] = None
) {

  def isTackTargetReached: Boolean = (tackTarget, controlMode) match {
    case (Some(t), FixedAngle) => abs(t - windAngle) < 0.1
    case (Some(t), FixedHeading) => abs(t - heading) < 0.1
    case (None, _) => false
  }

  def collision(boatWidth: Double, buoys: Seq[Buoy]): Option[Buoy] = buoys.find { buoy =>
    distanceBetween(buoy.position, position) <= buoy.radius + boatWidth / 2
  }

  def withSpell(spell: Spell) = copy(ownSpell = Some(spell))
}

object PlayerState {
  def initial(name: String) = PlayerState(
    name, (0,0), 0, 0, 0, 0, 0, 0, 0,
    FixedHeading, None, Seq(), Some(StartLine), None)
}

case class PlayerUpdate(id: String, input: PlayerInput, delta: Long)

case class RaceUpdate(
  now: DateTime,
  startTime: Option[DateTime],
  course: Option[Course],
  playerState: Option[PlayerState],
  wind: Wind,
  opponents: Seq[PlayerState] = Seq(),
  buoys: Seq[Buoy] = Seq(),
  triggeredSpells: Seq[Spell] = Seq(),
  leaderboard: Seq[String] = Seq(),
  isMaster: Boolean = false
)

object RaceUpdate {
  def initial(r: Race) = RaceUpdate(
    DateTime.now,
    startTime = None,
    playerState = None,
    course = Some(r.course),
    wind = Wind.default
  )
}

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

  implicit val controlModeFormat: Format[ControlMode] = new Format[ControlMode] {
    override def reads(json: JsValue): JsResult[ControlMode] = json match {
      case JsString("FixedAngle") => JsSuccess(FixedAngle)
      case JsString("FixedHeading") => JsSuccess(FixedHeading)
      case _ @ v => JsError(Seq(JsPath() -> Seq(ValidationError("Expected ControlMode value, got: " + v.toString))))
    }
    override def writes(o: ControlMode): JsValue = JsString(o match {
      case FixedAngle => "FixedAngle"
      case FixedHeading => "FixedHeading"
    })
  }

  import Course.courseFormat
  import Buoy.buoyFormat
  import Buoy.spellFormat

  implicit val arrowsFormat: Format[Arrows] = Json.format[Arrows]
  implicit val playerInputFormat: Format[PlayerInput] = Json.format[PlayerInput]
  implicit val playerUpdateFormat: Format[PlayerUpdate] = Json.format[PlayerUpdate]

  implicit val playerStateFormat: Format[PlayerState] = (
    (__ \ 'name).format[String] and
      (__ \ 'position).format[Geo.Point] and
      (__ \ 'heading).format[Double] and
      (__ \ 'velocity).format[Double] and
      (__ \ 'windAngle).format[Double] and
      (__ \ 'windOrigin).format[Double] and
      (__ \ 'windSpeed).format[Double] and
      (__ \ 'upwindVmg).format[Double] and
      (__ \ 'downwindVmg).format[Double] and
      (__ \ 'controlMode).format[ControlMode] and
      (__ \ 'tackTarget).format[Option[Double]] and
      (__ \ 'crossedGates).format[Seq[DateTime]] and
      (__ \ 'nextGate).format[Option[GateLocation]] and
      (__ \ 'ownSpell).format[Option[Spell]]
    )(PlayerState.apply, unlift(PlayerState.unapply))

  implicit val raceUpdateFormat: Format[RaceUpdate] = (
    (__ \ 'now).format[DateTime] and
      (__ \ 'startTime).format[Option[DateTime]] and
      (__ \ 'course).format[Option[Course]] and
      (__ \ 'player).format[Option[PlayerState]] and
      (__ \ 'wind).format[Wind] and
      (__ \ 'opponents).format[Seq[PlayerState]] and
      (__ \ 'buoys).format[Seq[Buoy]] and
      (__ \ 'triggeredSpells).format[Seq[Spell]] and
      (__ \ 'leaderboard).format[Seq[String]] and
      (__ \ 'isMaster).format[Boolean]
    )(RaceUpdate.apply, unlift(RaceUpdate.unapply))

}
