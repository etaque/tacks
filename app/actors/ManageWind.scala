package actors

import java.util.UUID
import org.joda.time.DateTime

import models._

trait ManageWind {

  def creationTime: DateTime
  def course: Course
  def clock: Long

  var wind = Wind.default
  var previousWindUpdate: Option[Long] = None

  def generateGust() = {
    val gen = course.gustGenerator
    val maxRadius = gen.generateRadius()
    val xSeed = Math.abs(clock * creationTime.getMillis * Math.PI)
    val gust = Gust(
      position = (course.area.genX(xSeed), course.area.top),
      angle = gen.generateOrigin(),
      speed = gen.generateSpeed(),
      radius = maxRadius,
      maxRadius = maxRadius,
      spawnedAt = clock
    )
    wind = wind.copy(gusts = wind.gusts :+ gust, gustCounter = wind.gustCounter + 1)
  }

  def updateWind(): Unit = {
    val c = clock
    val elapsed = previousWindUpdate.map(c - _)
    wind = wind.copy(
      origin = course.windGenerator.windOrigin(c),
      speed = course.windSpeed,
      gusts = elapsed.fold(wind.gusts)(e => moveGusts(c, wind.gusts, e))
    )
    previousWindUpdate = Some(c)
  }

  def moveGusts(clock: Long, gusts: Seq[Gust], elapsed: Long): Seq[Gust] = {
    gusts
      .map(_.update(course, wind, elapsed, clock))
      .filter(g => g.position._2 + g.radius > course.area.bottom)
  }

}
