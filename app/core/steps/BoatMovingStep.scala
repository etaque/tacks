package core.steps

import core.Sailing
import models.{Geo, PlayerState, Course}

object BoatMovingStep {

  def run(delta: Long, course: Course)(state: PlayerState): PlayerState = {

    val velocity = withInertia(state.velocity, Sailing.ac72Speed(state.windSpeed, state.windAngle))
    val nextPosition = Geo.movePoint(state.position, delta, velocity, state.heading)
    val position = if (isStuck(nextPosition, course)) state.position else nextPosition

    state.copy(velocity = velocity, position = position)
  }

  def withInertia(previousSpeed: Double, targetSpeed: Double): Double =
    previousSpeed + (targetSpeed - previousSpeed) * 0.02

  def isStuck(p: Geo.Point, course: Course): Boolean = {
    val (dl, dr) = course.downwind.segment
    val (ul, ur) = course.upwind.segment
    val halfBoatWidth = course.boatWidth / 2

    val stuckOnMark = Seq(dl, dr, ul, ur).exists(m => Geo.distanceBetween(p, m) <= course.markRadius + halfBoatWidth)
    val outOfBounds = !Geo.inBox(p, course.bounds)
    val onIsland = course.islands.exists(i => Geo.distanceBetween(i.location, p) <= i.radius + halfBoatWidth)

    stuckOnMark || outOfBounds || onIsland
  }
}
