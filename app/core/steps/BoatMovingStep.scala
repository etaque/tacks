package core.steps

import core.Sailing
import models.{Geo, PlayerState, Course}

object BoatMovingStep {

  def run(delta: Long, course: Course)(state: PlayerState): PlayerState = {

    val velocity = Sailing.withInertia(state.velocity, Sailing.ac72Speed(state.windSpeed, state.windAngle))
    val nextPosition = Geo.movePoint(state.position, delta, velocity, state.heading)
    val position = if (isStuck(nextPosition, course)) state.position else nextPosition

    state.copy(velocity = velocity, position = position)
  }

  def isStuck(p: Geo.Point, course: Course): Boolean = {
    false // TODO
  }
}
