package models

import org.joda.time.DateTime
import Geo._

case class Arrows(x: Int, y: Int)

case class PlayerInput (
  tack: Boolean,
  arrows: Arrows,
  subtleTurn: Boolean,
  lock: Boolean,
  startCountdown: Boolean)

sealed trait ControlMode
case object FixedHeading extends ControlMode
case object FixedAngle extends ControlMode

case class PlayerState (
  player: Player,
  time: DateTime,
  position: Point,
  isGrounded: Boolean,
  heading: Double,
  velocity: Double,
  windAngle: Double,
  windOrigin: Double,
  windSpeed: Double,
  upwindVmg: Double,
  downwindVmg: Double,
  trail: Seq[Point],
  controlMode: ControlMode,
  tackTarget: Option[Double],
  crossedGates: Seq[DateTime],
  nextGate: Option[GateLocation]
)

object PlayerState {
  def initial(player: Player) = PlayerState(
    player, DateTime.now, (0,0), false, 0, 0, 0, 0, 0, 0, 0, Seq(),
    FixedHeading, None, Seq(), Some(StartLine))
}

case class PlayerUpdate(player: Player, input: PlayerInput)

case class RaceUpdate(
  now: DateTime,
  startTime: Option[DateTime],
  course: Option[Course],
  playerState: Option[PlayerState],
  wind: Wind,
  opponents: Seq[PlayerState] = Seq(),
  leaderboard: Seq[PlayerTally] = Seq(),
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

case class RaceStatus(
  race: Race,
  master: Player,
  startTime: Option[DateTime],
  playerStates: Seq[(String, PlayerState)]
)
