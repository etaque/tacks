package models

import org.joda.time.DateTime
import Geo._
import play.api.i18n.Lang

case class Arrows(x: Int, y: Int)

case class PlayerInput (
  tack: Boolean,
  arrows: Arrows,
  subtleTurn: Boolean,
  lock: Boolean,
  startCountdown: Boolean
)

object PlayerInput {
  val initial = PlayerInput(
    tack = false,
    arrows = Arrows(0, 0),
    subtleTurn = false,
    lock = false,
    startCountdown = false
  )
}

sealed trait ControlMode
case object FixedHeading extends ControlMode
case object FixedAngle extends ControlMode

case class Vmg(
  angle: Double,
  speed: Double,
  value: Double
)

case class PlayerState (
  player: Player,
  time: DateTime,
  position: Point,
  isGrounded: Boolean,
  heading: Double,
  velocity: Double,
  vmgValue: Double,
  windAngle: Double,
  windOrigin: Double,
  windSpeed: Double,
  upwindVmg: Vmg,
  downwindVmg: Vmg,
  trail: Seq[Point],
  controlMode: ControlMode,
  tackTarget: Option[Double],
  crossedGates: Seq[DateTime],
  nextGate: Option[GateLocation]
)

object PlayerState {
  def initial(player: Player) = PlayerState(
    player, DateTime.now, (0,0), false, 0, 0, 0, 0, 0, 0, Vmg(0, 0, 0), Vmg(0, 0, 0), Seq(),
    FixedHeading, None, Seq(), Some(StartLine))
}

case class PlayerUpdate(player: Player, input: PlayerInput)

case class WatcherInput(
  watchedPlayerId: String
)

case class WatcherState(
  watchedPlayerId: String
)

case class WatcherUpdate(watcher: Player, input: WatcherInput)

case class RaceUpdate(
  now: DateTime,
  startTime: Option[DateTime],
  course: Option[Course],
  playerState: Option[PlayerState],
  wind: Wind,
  opponents: Seq[PlayerState] = Seq(),
  leaderboard: Seq[PlayerTally] = Seq(),
  isMaster: Boolean = false,
  langCode: Option[String] = None
)

object RaceUpdate {
  def initial(r: Race, lang: Lang) = RaceUpdate(
    DateTime.now,
    startTime = None,
    playerState = None,
    course = Some(r.course),
    wind = Wind.default,
    langCode = Some(lang.code)
  )
}

case class RaceStatus(
  race: Race,
  master: Player,
  startTime: Option[DateTime],
  playerStates: Seq[PlayerState]
)
