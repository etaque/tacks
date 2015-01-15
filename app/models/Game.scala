package models

import reactivemongo.bson.BSONObjectID
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
) {
  def manualTurn = arrows.x != 0
  def isTurning = manualTurn && !subtleTurn
  def isSubtleTurning = manualTurn && subtleTurn
  def isLocking = arrows.y > 0 || lock
}

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
  def upwind = math.abs(windAngle) < 90
  def closestVmgAngle = if (upwind) upwindVmg.angle else downwindVmg.angle
  def headingOnVmg = Geo.ensure360(if (windAngle < 0) windOrigin - closestVmgAngle else windOrigin + closestVmgAngle)
  def deltaToVmg = Geo.angleDelta(heading, headingOnVmg)

  def toDebug = s"t:$time turning:$isTurning heading:$heading windAngle:$windAngle control:$controlMode tack:$tackTarget"
}

object PlayerState {
  def initial(player: Player) = PlayerState(
    player, DateTime.now.getMillis, (0,0), false, false, 0, 0, 0, 0, 0, 0, Vmg(0, 0, 0), Vmg(0, 0, 0), 0, Seq(),
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

case class GhostRun(
  run: TimeTrialRun,
  tracks: Seq[RunTrack],
  playerId: BSONObjectID,
  playerHandle: Option[String]
)

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
  playerId: String,
  now: DateTime,
  startTime: Option[DateTime],
  course: Option[Course],
  playerState: Option[PlayerState],
  wind: Wind,
  opponents: Seq[PlayerState] = Nil,
  ghosts: Seq[GhostState] = Nil,
  leaderboard: Seq[PlayerTally] = Nil,
  isMaster: Boolean = false,
  langCode: Option[String] = None,
  watching: Boolean = false,
  timeTrial: Boolean = false
)

object RaceUpdate {
  def initial(player: Player, course: Course, watching: Boolean = false, timeTrial: Boolean = false)(implicit lang: Lang) =
    RaceUpdate(
      player.id.stringify,
      DateTime.now,
      startTime = None,
      playerState = None,
      course = Some(course),
      wind = Wind.default,
      langCode = Some(lang.code),
      watching = watching,
      timeTrial = timeTrial
    )
}

case class RaceStatus(
  race: Race,
  master: Player,
  startTime: Option[DateTime],
  playerStates: Seq[PlayerState]
)
