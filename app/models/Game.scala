package models

import java.util.UUID
import org.joda.time.DateTime
import play.api.i18n.Lang

import Geo._


case class Arrows(x: Int, y: Int)

case class KeyboardInput(
  tack: Boolean,
  arrows: Arrows,
  subtleTurn: Boolean,
  lock: Boolean
)

object KeyboardInput {
  val initial = KeyboardInput(
    tack = false,
    arrows = Arrows(0, 0),
    subtleTurn = false,
    lock = false
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

case class PlayerState(
  player: Player,
  time: Float,
  position: Point,
  isGrounded: Boolean,
  isTurning: Boolean,
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
  nextGate: Option[Gate]
)

object PlayerState {
  def initial(player: Player) = PlayerState(
    player, DateTime.now.getMillis.toFloat, (0,0), false, false, 0, 0, 0, 0, 0, 0, Vmg(0, 0, 0), Vmg(0, 0, 0), 0, Seq(),
    FixedHeading, None, Seq(), None)
}

case class OpponentState(
  time: Long,
  position: Point,
  heading: Double,
  velocity: Double,
  windAngle: Double,
  windOrigin: Double,
  shadowDirection: Double,
  crossedGates: Seq[Long]
) {
  def hasFinished(course: Course): Boolean =
    crossedGates.length == course.gates.length + 1
}

object OpponentState {
  def initial = OpponentState(
    time = 0,
    position = (0,0),
    heading = 0,
    velocity = 0,
    windAngle = 0,
    windOrigin = 0,
    shadowDirection = 0,
    crossedGates = Nil
  )
}

case class Opponent(
  state: OpponentState,
  player: Player
)

case class PlayerInput(state: OpponentState, localTime: Long)
case class PlayerUpdate(player: Player, playerInput: PlayerInput)


case class RaceUpdate(
  serverTime: DateTime,
  startTime: Option[DateTime],
  wind: Wind,
  opponents: Seq[Opponent],
  ghosts: Seq[GhostState],
  tallies: Seq[PlayerTally],
  isMaster: Boolean = false,
  initial: Boolean = false,
  clientTime: Float = 0
)

object RaceUpdate {
  def initial =
    RaceUpdate(
      DateTime.now,
      startTime = None,
      wind = Wind.default,
      opponents = Nil,
      ghosts = Nil,
      tallies = Nil,
      initial = true
    )
}

case class LiveTrack(
  track: Track,
  meta: TrackMeta,
  races: Seq[Race],
  players: Seq[Player]
)

case class TrackMeta(
  creator: User,
  rankings: Seq[PlayerRanking],
  runsCount: Long
)

case class PlayerRanking(
  rank: Long,
  runId: UUID,
  player: Player,
  finishTime: Long
)

case class Message(
  player: Player,
  content: String,
  time: DateTime
)
