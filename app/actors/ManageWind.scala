package actors

import models._
import reactivemongo.bson.BSONObjectID

trait ManageWind {

  def id: BSONObjectID
  def course: Course
  def clock: Long
  def startScheduled: Boolean

  var wind = Wind.default
  var previousWindUpdate: Option[Long] = None
  var gustCounter = 0

  def clockSecond = clock / 1000

  def generateGust() = {
    course.gustGenerator.nthDef(gustCounter).foreach { gustDef =>
      val gust = Gust(
        position = (course.area.genX(clockSecond * id.timeSecond + id.timeSecond, 100), course.area.top),
        angle = gustDef.angle,
        speed = gustDef.speed,
        radius = 0,
        maxRadius = gustDef.radius,
        spawnedAt = clock
      )
      wind = wind.copy(gusts = wind.gusts :+ gust)
      gustCounter += 1
    }
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
