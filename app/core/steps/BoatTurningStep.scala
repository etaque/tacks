package core.steps

import models._

object BoatTurningStep {

  // degrees / ms
  val slow = 0.03
  val autoTack = 0.08
  val fast = 0.1

  def run(previousState: PlayerState, input: KeyboardInput, elapsed: Long)(state: PlayerState): PlayerState = {
    val lock = input.lock || input.arrows.y > 0

    val targetReached = tackTargetReached(state)

    val tackTarget = getTackTarget(state, input, targetReached)

    val turn = getTurn(tackTarget, state, input, elapsed)
    val heading = Geo.ensure360(state.heading + turn)
    val windAngle = Geo.angleDelta(heading, state.windOrigin)

    val newControlMode =
      if (input.manualTurn) FixedHeading
      else if (lock || targetReached) FixedAngle
      else state.controlMode

    state.copy(
      heading = heading,
      windAngle = windAngle,
      isTurning = input.isTurning,
      tackTarget = tackTarget,
      controlMode = newControlMode
    )
  }

  def tackTargetReached(state: PlayerState): Boolean = {
    state.tackTarget.exists { target =>
      math.abs(Geo.angleDelta(state.windAngle, target)) < 1
    }
  }

  def getTackTarget(state: PlayerState, input: KeyboardInput, targetReached: Boolean): Option[Double] = {
    if (input.manualTurn) {
      // a manual turn means no tack
      None

    } else {
      // no manual turn => any previous tack in progress?
      state.tackTarget match {

        case Some(_) => {
          // yes => check target
          if (targetReached) {
            None
          } else {
            state.tackTarget
          }
        }

        case None => {
          // no => maybe player triggered one
          if (input.tack) {
            Some(-state.windAngle)
          }
          else {
            autoVmgTarget(state, input)
          }
        }
      }
    }
  }

  def autoVmgTarget(state: PlayerState, input: KeyboardInput): Option[Double] = {
    if (state.crossedGates.nonEmpty && state.isTurning &&
      !input.manualTurn && math.abs(state.deltaToVmg) < state.player.vmgMagnet) {

      Some(state.windAngleOnVmg)

    } else {
      None
    }
  }

  def getTurn(tackTarget: Option[Double], state: PlayerState, input: KeyboardInput, elapsed: Long): Double = {

    if (input.manualTurn) {
      val rotation = if (input.subtleTurn) slow else fast
      input.arrows.x * elapsed * rotation

    } else {
      tackTarget match {

        case Some(t) => {
          // tack target in progress on fixed angle mode
          val turn = elapsed * autoTack
          val targetDelta = Geo.angleDelta(t, state.windAngle)

          if (math.abs(targetDelta) < math.abs(turn)) {
            targetDelta
          } else {
            if (targetDelta < 0) -turn else turn
          }
        }

        case None => {
          state.controlMode match {
            case FixedHeading => {
              // no tack, fixed heading => no turn
              0
            }
            case FixedAngle => {
              // no tack, fixed angle => adapt to wind origin
              Geo.ensure360(state.windOrigin + state.windAngle - state.heading)
            }
          }
        }
      }
    }

  }

}
