package models

import Math._
import play.api.libs.json._

object Geo {
  type Point = (Double,Double) // (x,y)
  type Segment = (Point,Point)
  type Box = (Point,Point) // ((right,top),(left,bottom))

  def distanceBetween(p1: Point, p2: Point): Double = {
    val (x1,y1) = p1
    val (x2,y2) = p2
    sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2))
  }

  def inBox(p: Point, b: Box): Boolean = {
    val (x,y) = p
    val ((right, top), (left, bottom)) = b
    x > left && x < right && y > bottom && y < top
  }

  /**
   * Move on!
   * @param p initial position
   * @param milliseconds time elapsed in ms
   * @param velocity in m/s
   * @param heading in degrees
   * @return next position
   */
  def movePoint(p: Point, milliseconds: Long, velocity: Double, heading: Double): Point = {
    val (x,y) = p
    val rad = angleToRadians(heading)
    val x1 = x + milliseconds * 0.001 * velocity * cos(rad)
    val y1 = y + milliseconds * 0.001 * velocity * sin(rad)
    (x1, y1)
  }

  def angleToRadians(angle: Double): Double = toRadians(-angle - 90)

  def ensure360(d: Double): Double = (d + 360) % 360

  def angleBetween(a1: Double, a2: Double): Double = {
    val delta = a1 - a2
    if (delta > 180) delta - 360
    else if (delta <= -180) delta + 360
    else delta
  }

  implicit val pointFormat: Format[Point] = utils.JsonFormats.tuple2Format[Double,Double]
  implicit val boxFormat: Format[Box] = utils.JsonFormats.tuple2Format[Point,Point]
}
