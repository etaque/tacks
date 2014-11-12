package core.steps

import models._

object BoatTurningStep {

  // degrees / ms
  val slow = 0.03
  val medium = 0.06
  val fast = 0.1

  def run(previousState: PlayerState, input: PlayerInput, elapsed: Long)(state: PlayerState): PlayerState = {
    val manualTurn = input.arrows.x != 0
    val lock = input.lock || input.arrows.y > 0

    val tackTarget = if (manualTurn) None else state.tackTarget match {

      case Some(_) =>
        if (tackTargetReached(state)(previousState)) None
        else state.tackTarget

      case None =>
        if (input.tack) state.controlMode match {
          case FixedAngle => Some(-state.windAngle)
          case FixedHeading => Some(Geo.ensure360(state.windOrigin - state.windAngle))
        }
        else None
    }

    val turn = getTurn(tackTarget, state, input, elapsed)
    val heading = Geo.ensure360(state.heading + turn)
    val windAngle = Geo.angleDelta(heading, state.windOrigin)

    val turnedState = state.copy(heading = heading, windAngle = windAngle)

    val tackTargetAfterTurn = if (tackTargetReached(turnedState)(previousState)) None else tackTarget
    val newControlMode = if (manualTurn) FixedHeading else if (lock) FixedAngle else turnedState.controlMode

    turnedState.copy(tackTarget = tackTargetAfterTurn, controlMode = newControlMode)
  }

  def getTurn(tackTarget: Option[Double], state: PlayerState, input: PlayerInput, elapsed: Long): Double = {
    (tackTarget, state.controlMode, input.arrows.x) match {
      case (Some(t), FixedHeading, _) => {
        val turn = elapsed * medium
        val maxTurn = Seq(turn, Math.abs(state.heading - t)).min
        if (Geo.ensure360(state.heading - t) > 180) maxTurn else -maxTurn
      }
      case (Some(t), FixedAngle, _) => {
        val turn = elapsed * medium
        val maxTurn = Seq(turn, Math.abs(state.windAngle - t)).min
        if (t > 90 || (t < 0 && t >= -90)) -maxTurn else maxTurn
      }
      case (None, FixedHeading, 0) => 0
      case (None, FixedAngle, 0) => Geo.ensure360(state.windOrigin + state.windAngle - state.heading)
      case (None, _, turnArrow) =>
        if (input.subtleTurn || input.arrows.y < 0)
          turnArrow * elapsed * slow
        else
          turnArrow * elapsed * fast
    }
  }

  def tackTargetReached(after: PlayerState)(before: PlayerState): Boolean = {
    (after.tackTarget, after.controlMode) match {
      case (Some(t), FixedAngle) => {
        val beforeDelta = Geo.angleDelta(before.windAngle, t).round
        val afterDelta = Geo.angleDelta(after.windAngle, t).round
        beforeDelta < 0 && afterDelta >= 0 || beforeDelta > 0 && afterDelta <= 0
      }
      case (Some(t), FixedHeading) => {
        val beforeDelta = Geo.angleDelta(before.heading, t).round
        val afterDelta = Geo.angleDelta(after.heading, t).round
        beforeDelta < 0 && afterDelta >= 0 || beforeDelta > 0 && afterDelta <= 0
      }
      case (None, _) => false
    }
  }
}
