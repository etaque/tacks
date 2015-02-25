package actors

import models._
import reactivemongo.bson.BSONObjectID

trait ManageWind {

  def id: BSONObjectID
  def course: Course
  def clock: Long

  var wind = Wind.default
  var previousWindUpdate: Option[Long] = None

  def generateGust() = {
    course.gustGenerator.nthDef(wind.gustCounter).foreach { gustDef =>
      val c = clock
      val cs = c / 1000
      val gust = Gust(
        position = (course.area.genX(cs * id.timeSecond + id.timeSecond, 100), course.area.top),
        angle = gustDef.angle,
        speed = gustDef.speed,
        radius = 0,
        maxRadius = gustDef.radius,
        spawnedAt = clock
      )
      wind = wind.copy(gusts = wind.gusts :+ gust, gustCounter = wind.gustCounter + 1)
    }
  }

  def updateWind(): Unit = {
    val c = clock
    val elapsed = previousWindUpdate.map(c - _)
    wind = wind.copy(
      origin = course.windGenerator.windOrigin(c),
      speed = course.windGenerator.windSpeed(c),
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
