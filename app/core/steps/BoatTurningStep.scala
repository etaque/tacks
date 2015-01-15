package core.steps

import models._

object BoatTurningStep {

  // degrees / ms
  val slow = 0.03
  val autoTack = 0.08
  val fast = 0.1

  def run(previousState: PlayerState, input: PlayerInput, elapsed: Long)(state: PlayerState): PlayerState = {
    val lock = input.lock || input.arrows.y > 0

    val tackTarget = if (input.manualTurn) {
      // a manual turn means no tack
      None

    } else {
      // no manual turn => any previous tack in progress?
      state.tackTarget match {

        case Some(_) => {
          // yes => check target
          if (tackTargetReached(state)(previousState)) {
            None
          } else {
            state.tackTarget
          }
        }

        case None => {
          // no => maybe player triggered one
          if (input.tack) {
            state.controlMode match {
              case FixedAngle => Some(-state.windAngle)
              case FixedHeading => Some(Geo.ensure360(state.windOrigin - state.windAngle))
            }
          }
          else {
            autoVmgHeading(state, input)
          }
        }
      }
    }

    val turn = getTurn(tackTarget, state, input, elapsed)
    val heading = Geo.ensure360(state.heading + turn)
    val windAngle = Geo.angleDelta(heading, state.windOrigin)

    val turnedState = state.copy(heading = heading, windAngle = windAngle, isTurning = input.isTurning, tackTarget = tackTarget)

    val tackTargetAfterTurn = if (tackTargetReached(turnedState)(previousState)) {
      None
    } else {
      tackTarget
    }
    val newControlMode = if (input.manualTurn) FixedHeading else if (lock) FixedAngle else turnedState.controlMode

    turnedState.copy(tackTarget = tackTargetAfterTurn, controlMode = newControlMode)
  }

  def autoVmgHeading(state: PlayerState, input: PlayerInput): Option[Double] = {
    lazy val absDeltaToVmg = math.abs(state.deltaToVmg)
    if (state.isTurning && !input.manualTurn && absDeltaToVmg < 10 && absDeltaToVmg > 2) {
      Some(state.headingOnVmg)
    } else {
      None
    }
  }

  def getTurn(tackTarget: Option[Double], state: PlayerState, input: PlayerInput, elapsed: Long): Double = {
    (tackTarget, state.controlMode, input.manualTurn) match {

      case (Some(t), FixedHeading, _) => {
        // tack in progress on fixed heading mode
        val turn = elapsed * autoTack
        val maxTurn = Seq(turn, Math.abs(state.heading - t)).min
        if (Geo.ensure360(state.heading - t) > 180) maxTurn else -maxTurn
      }

      case (Some(t), FixedAngle, _) => {
        // tack target in progress on fixed angle mode
        val turn = elapsed * autoTack
        val maxTurn = Seq(turn, Math.abs(state.windAngle - t)).min
        if (t > 90 || (t < 0 && t >= -90)) -maxTurn else maxTurn
      }

      case (None, FixedHeading, false) => {
        // no tack, fixed heading => no turn
        0
      }

      case (None, FixedAngle, false) => {
        // no tack, fixed angle => adapt to wind origin
        Geo.ensure360(state.windOrigin + state.windAngle - state.heading)
      }

      case (None, _, _) => {
        // no tack, but manual turn
        val rotation = if (input.subtleTurn) slow else fast
        input.arrows.x * elapsed * rotation
      }
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
