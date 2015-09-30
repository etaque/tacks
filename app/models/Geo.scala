package models

import Math._
import play.api.libs.json._
import reactivemongo.bson._

object Geo {
  type Point = (Double,Double) // (x,y)
  type Segment = (Point,Point)
  type Box = (Point,Point) // ((right,top),(left,bottom))

  /**
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

  def angleToRadians(angle: Double): Double = toRadians(-angle + 90)
  def radiansToAngle(rad: Double): Double = toDegrees(rad) + 90

  def ensure360(d: Double): Double = (d + 360) % 360

  import reactivemongo.bson.{BSONDoubleHandler => dh}
  implicit val pointHandler = new BSONHandler[BSONArray, (Double, Double)] {
    def read(array: BSONArray) = (dh.read(array.getAs[BSONDouble](0).get), dh.read(array.getAs[BSONDouble](1).get))
    def write(tuple: (Double, Double)) = BSONArray(dh.write(tuple._1), dh.write(tuple._2))
  }

  implicit val pointFormat: Format[Point] = _root_.tools.JsonFormats.tuple2Format[Double,Double]
  implicit val boxFormat: Format[Box] = _root_.tools.JsonFormats.tuple2Format[Point,Point]
}
