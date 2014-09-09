package core.steps

import models._

object BoatHandlingStep {

  def run(input: PlayerInput)(state: PlayerState): PlayerState = {
    val turned = input.arrows.x != 0
    val tackTarget = if (turned) None else getTackTarget(state, input.tack)
    val turn = getTurn(tackTarget, state, input)
    val heading = Geo.ensure360(state.heading + turn) // TODO inversion spell
    val windAngle = Geo.angleBetween(heading, state.windOrigin)

    val turnedState = state.copy(heading = heading, windAngle = windAngle)

    val tackTargetAfterTurn = if (turnedState.isTackTargetReached) None else tackTarget
    val newControlMode = if (turned) FixedHeading else if (input.lock) FixedAngle else turnedState.controlMode

    turnedState.copy(tackTarget = tackTargetAfterTurn, controlMode = newControlMode)
  }

  def getTackTarget(state: PlayerState, tacking: Boolean): Option[Double] = {
    (state.tackTarget, tacking) match {
      case (Some(_), _) => if (state.isTackTargetReached) None else state.tackTarget
      case (None, true) => state.controlMode match {
        case FixedAngle => Some(-state.windAngle)
        case FixedHeading => Some(Geo.ensure360(state.windOrigin - state.windAngle))
      }
      case _ => None
    }
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
}
