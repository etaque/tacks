package models

import java.lang.Math._
import java.util.UUID
import models.Geo._
import play.api.libs.json.{Json, Format}


case class Gust(
  id: UUID,
  position: Point,
  angle: Double, // degrees
  speed: Double,
  radius: Double,
  maxRadius: Double,
  spawnedAt: Long // race time, ms
) {
  // val pixelPerSecond = 1
  val maxRadiusAfterSeconds = 5

  def step(course: Course, wind: Wind, elapsed: Long): Gust = {
    val groundSpeed = (wind.speed + speed)
    val groundDirection = ensure360(angle + 180)
    val newPosition = movePoint(position, elapsed, groundSpeed, groundDirection)
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
