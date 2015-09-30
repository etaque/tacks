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
)

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
)

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
) {
  def hasFinished(course: Course): Boolean =
    crossedGates.length == course.laps * 2 + 1
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

case class RaceUpdate(
  serverNow: DateTime,
  startTime: Option[DateTime],
  wind: Wind,
  opponents: Seq[Opponent] = Nil,
  ghosts: Seq[GhostState] = Nil,
  tallies: Seq[PlayerTally] = Nil,
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

case class LiveTrackUpdate(liveTrack: LiveTrack)

case class LiveTrack(
  track: Track,
  races: Seq[Race],
  players: Seq[Player],
  rankings: Seq[PlayerRanking]
)

case class PlayerRanking(
  rank: Int,
  player: Player,
  finishTime: Long
)

case class Message(
  player: Player,
  content: String,
  time: DateTime
)
