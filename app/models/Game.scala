package models

import reactivemongo.bson.BSONObjectID
import org.joda.time.DateTime
import Geo._
import play.api.i18n.Lang

case class Arrows(x: Int, y: Int)

case class KeyboardInput(
  tack: Boolean,
  arrows: Arrows,
  subtleTurn: Boolean,
  lock: Boolean,
  startCountdown: Boolean,
  escapeRace: Boolean
) {
  def manualTurn = arrows.x != 0
  def isTurning = manualTurn && !subtleTurn
  def isSubtleTurning = manualTurn && subtleTurn
  def isLocking = arrows.y > 0 || lock
}

object KeyboardInput {
  val initial = KeyboardInput(
    tack = false,
    arrows = Arrows(0, 0),
    subtleTurn = false,
    lock = false,
    startCountdown = false,
    escapeRace = false
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
  time: Long,
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
  nextGate: Option[GateLocation]
) {
  lazy val upwind = math.abs(windAngle) < 90
  lazy val closestVmgAngle = if (upwind) upwindVmg.angle else downwindVmg.angle
  lazy val windAngleOnVmg = if (windAngle < 0) -closestVmgAngle else closestVmgAngle
  lazy val headingOnVmg = Geo.ensure360(windOrigin + closestVmgAngle)
  lazy val deltaToVmg = windAngle - windAngleOnVmg

  def toDebug = s"t:$time turning:$isTurning heading:$heading windAngle:$windAngle control:$controlMode tack:$tackTarget"
}

object PlayerState {
  def initial(player: Player) = PlayerState(
    player, DateTime.now.getMillis, (0,0), false, false, 0, 0, 0, 0, 0, 0, Vmg(0, 0, 0), Vmg(0, 0, 0), 0, Seq(),
    FixedHeading, None, Seq(), Some(StartLine))
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
)

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

case class PlayerInput(state: OpponentState, input: KeyboardInput, localTime: Long)
case class PlayerUpdate(player: Player, playerInput: PlayerInput)

// case class GhostRun(
//   run: TimeTrialRun,
//   tracks: Seq[RunTrack],
//   playerId: BSONObjectID,
//   playerHandle: Option[String]
// )

case class GhostState(
  position: Point,
  heading: Double,
  id: BSONObjectID,
  handle: Option[String],
  gates: Seq[Long]
)

object GhostState {
  def initial(id: BSONObjectID, handle: Option[String], gates: Seq[Long]) = GhostState((0,0), 0, id, handle, gates)
}

case class GameSetup(
  now: DateTime,
  creationTime: DateTime,
  countdown: Int,
  player: Player,
  course: Course,
  gameMode: String
)

case class RaceUpdate(
  serverNow: DateTime,
  startTime: Option[DateTime],
  wind: Wind,
  opponents: Seq[Opponent] = Nil,
  ghosts: Seq[GhostState] = Nil,
  leaderboard: Seq[PlayerTally] = Nil,
  isMaster: Boolean = false,
  initial: Boolean = false,
  clientTime: Long = 0
)

object RaceUpdate {
  def initial =
    RaceUpdate(
      DateTime.now,
      startTime = None,
      wind = Wind.default,
      initial = true
    )
}

// case class RaceStatus(
//   race: Race,
//   master: Option[Player],
//   startTime: Option[DateTime],
//   opponents: Seq[Opponent]
// )

case class LiveTrack(
  track: Track,
  nextRace: Option[Race],
  players: Seq[Player]
)
