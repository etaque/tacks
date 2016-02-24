package models

import java.lang.Math._

import models.Geo._
import play.api.libs.json.{Json, Format}


case class Gust(
  position: Point,
  angle: Double, // degrees
  speed: Double,
  radius: Double,
  maxRadius: Double,
  spawnedAt: Long // race time, ms
) {
  // val pixelPerSecond = 1
  val maxRadiusAfterSeconds = 5

  def update(course: Course, wind: Wind, elapsed: Long, clock: Long): Gust = {
    val groundSpeed = (wind.speed + speed)
    val groundDirection = ensure360(angle + 180)
    val newPosition = movePoint(position, elapsed, groundSpeed, groundDirection)
    // val radius = min((clock - spawnedAt) * 0.001 * maxRadius / maxRadiusAfterSeconds, maxRadius)
    copy(position = newPosition, radius = maxRadius)
  }
}

case class Wind(
  origin: Double,
  speed: Double,
  gusts: Seq[Gust],
  gustCounter: Int
)

object Wind {
  val defaultWindSpeed = 17
  val default = Wind(0, defaultWindSpeed, Nil, 0)

  implicit val gustFormat: Format[Gust] = Json.format[Gust]
  implicit val windFormat: Format[Wind] = Json.format[Wind]
}
