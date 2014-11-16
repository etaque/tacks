package actors

import models._

trait ManageWind {

  def course: Course
  def clock: Long
  def startScheduled: Boolean

  var wind = Wind.default
  var previousWindUpdate: Option[Long] = None

  def generateGust() = {
    wind = wind.copy(gusts = wind.gusts :+ Gust.generate(course, clock))
  }

  def updateWind(): Unit = {
    val elapsed = previousWindUpdate.map(clock - _)
    wind = Wind(
      origin = course.windGenerator.windOrigin(clock),
      speed = course.windGenerator.windSpeed(clock),
      gusts = elapsed.fold(wind.gusts)(e => moveGusts(clock, wind.gusts, e))
    )
    previousWindUpdate = Some(clock)
  }

  def moveGusts(clock: Long, gusts: Seq[Gust], elapsed: Long): Seq[Gust] = {
    gusts
      .map(_.update(course, wind, elapsed, clock))
      .filter(g => g.position._2 - g.radius > course.area.bottom)
  }

}
