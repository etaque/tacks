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
  time: Long,
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
  shadowDirection: Double,
  trail: Seq[Point],
  controlMode: ControlMode,
  tackTarget: Option[Double],
  crossedGates: Seq[Long],
  nextGate: Option[GateLocation]
)

object PlayerState {
  def initial(player: Player) = PlayerState(
    player, DateTime.now.getMillis, (0,0), false, 0, 0, 0, 0, 0, 0, Vmg(0, 0, 0), Vmg(0, 0, 0), 0, Seq(),
    FixedHeading, None, Seq(), Some(StartLine))
}

case class PlayerUpdate(player: Player, input: PlayerInput)

case class WatcherInput(
  watchedPlayerId: Option[String]
)

case class WatcherState(
  watchedPlayerId: String
)

case class WatcherUpdate(watcher: Player, input: WatcherInput)

case class RaceUpdate(
  playerId: String,
  now: DateTime,
  startTime: Option[DateTime],
  course: Option[Course],
  playerState: Option[PlayerState],
  wind: Wind,
  opponents: Seq[PlayerState] = Seq(),
  leaderboard: Seq[PlayerTally] = Seq(),
  isMaster: Boolean = false,
  langCode: Option[String] = None,
  watching: Boolean = false
)

object RaceUpdate {
  def initial(player: Player, course: Course, lang: Lang, watching: Boolean) = RaceUpdate(
    player.id.stringify,
    DateTime.now,
    startTime = None,
    playerState = None,
    course = Some(course),
    wind = Wind.default,
    langCode = Some(lang.code),
    watching = watching
  )
}

case class RaceStatus(
  race: Race,
  master: Player,
  startTime: Option[DateTime],
  playerStates: Seq[PlayerState]
)
