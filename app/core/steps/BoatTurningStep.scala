package core.steps

import models._

object BoatTurningStep {

  def run(previousStateMaybe: Option[PlayerState], input: PlayerInput, triggeredSpells: Seq[Spell])(state: PlayerState): PlayerState = {
    val manualTurn = input.arrows.x != 0

    val tackTarget = if (manualTurn) None else state.tackTarget match {

      case Some(_) =>
        if (previousStateMaybe.exists(tackTargetReached(state))) None
        else state.tackTarget

      case None =>
        if (input.tack) state.controlMode match {
          case FixedAngle => Some(-state.windAngle)
          case FixedHeading => Some(Geo.ensure360(state.windOrigin - state.windAngle))
        }
        else None
    }

    val turn = getTurn(tackTarget, state, input)
    val inverted = triggeredSpells.exists(_.kind == PoleInversion)
    val heading = Geo.ensure360(state.heading + (if (inverted) -turn else turn))
    val windAngle = Geo.angleDelta(heading, state.windOrigin)

    val turnedState = state.copy(heading = heading, windAngle = windAngle)

    val tackTargetAfterTurn = if (previousStateMaybe.exists(tackTargetReached(turnedState))) None else tackTarget
    val newControlMode = if (manualTurn) FixedHeading else if (input.lock) FixedAngle else turnedState.controlMode

    turnedState.copy(tackTarget = tackTargetAfterTurn, controlMode = newControlMode)
  }

  def getTurn(tackTarget: Option[Double], state: PlayerState, input: PlayerInput): Double = {
    (tackTarget, state.controlMode, input.arrows.x) match {
      case (Some(t), FixedHeading, _) => {
        val maxTurn = Seq(2.0, Math.abs(state.heading - t)).min
        if (Geo.ensure360(state.heading - t) > 180) maxTurn else -maxTurn
      }
      case (Some(t), FixedAngle, _) => {
        val maxTurn = Seq(2.0, Math.abs(state.windAngle - t)).min
        if (t > 90 || (t < 0 && t >= -90)) -maxTurn else maxTurn
      }
      case (None, FixedHeading, 0) => 0
      case (None, FixedAngle, 0) => Geo.ensure360(state.windOrigin + state.windAngle - state.heading)
      case (None, _, turn) => if (input.subtleTurn) turn else turn * 3
    }
  }

  def tackTargetReached(after: PlayerState)(before: PlayerState): Boolean = {
    (after.tackTarget, after.controlMode) match {
      case (Some(t), FixedAngle) => {
        val beforeDelta = Geo.angleDelta(before.windAngle, t)
        val afterDelta = Geo.angleDelta(after.windAngle, t)
        beforeDelta < 0 && afterDelta >= 0 || beforeDelta > 0 && afterDelta <= 0
      }
      case (Some(t), FixedHeading) => {
        val beforeDelta = Geo.angleDelta(before.heading, t)
        val afterDelta = Geo.angleDelta(after.heading, t)
        beforeDelta < 0 && afterDelta >= 0 || beforeDelta > 0 && afterDelta <= 0
      }
      case (None, _) => false
    }
  }
}
