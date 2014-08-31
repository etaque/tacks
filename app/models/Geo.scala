package models

import play.api.libs.json._

object Geo {
  type Point = (Float,Float) // (x,y)
  type Segment = (Point,Point)
  type Box = (Point,Point) // ((right,top),(left,bottom))

  def distanceBetween(p1: Point, p2: Point): Double = {
    val (x1,y1) = p1
    val (x2,y2) = p2
    Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2))
  }

  def inBox(p: Point, b: Box): Boolean = {
    val (x,y) = p
    val ((right, top), (left, bottom)) = b
    x > left && x < right && y > bottom && y < top
  }

  implicit val pointFormat: Format[Point] = utils.JsonFormats.tuple2Format[Float,Float]
  implicit val boxFormat: Format[Box] = utils.JsonFormats.tuple2Format[Point,Point]
}
