package core.steps

import core.Sailing
import models.{Geo, PlayerState, Course}

object BoatMovingStep {

  /**
   * Updates player velocity and position
   * @param elapsed time elapsed in ms
   * @param course for grounding detection
   * @param state to update
   * @return updated player state
   */
  def run(elapsed: Long, course: Course)(state: PlayerState): PlayerState = {

    val nextVelocity = withInertia(elapsed: Long, state.velocity, Sailing.ac72Speed(state.windSpeed, state.windAngle))
    val nextPosition = Geo.movePoint(state.position, elapsed, nextVelocity, state.heading)
    
    val grounded = isGrounded(nextPosition, course)
    
    val velocity = if (grounded) 0 else nextVelocity
    val position = if (grounded) state.position else nextPosition

    val trail = (position +: state.trail).take(20)

    state.copy(velocity = velocity, position = position, trail = trail)
  }

  val maxAccel = 0.03

  def withInertia(elapsed: Long, previousVelocity: Double, targetVelocity: Double): Double = {
    val velocityDelta = targetVelocity - previousVelocity
    val accel = velocityDelta / elapsed
    val realAccel = if (accel > 0) math.min(accel, maxAccel) else math.max(accel, -maxAccel)
    previousVelocity + realAccel * elapsed
  }

  def isGrounded(p: Geo.Point, course: Course): Boolean = {
    val (dl, dr) = course.downwind.segment
    val (ul, ur) = course.upwind.segment
    val halfBoatWidth = course.boatWidth / 2

    val stuckOnMark = Seq(dl, dr, ul, ur).exists(m => Geo.distanceBetween(p, m) <= course.markRadius + halfBoatWidth)
    val outOfBounds = !Geo.inBox(p, course.area.toBox)
    val onIsland = course.islands.exists(i => Geo.distanceBetween(i.location, p) <= i.radius + halfBoatWidth)

    stuckOnMark || outOfBounds || onIsland
  }
}
