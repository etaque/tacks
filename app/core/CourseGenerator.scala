package core

import models._
import org.joda.time.LocalDate
import play.api.libs.concurrent.Execution.Implicits._

import scala.concurrent.Future
import scala.util.Random

trait CourseGenerator {
  def slug: String
  def generateCourse(): Course
}

object WarmUp extends CourseGenerator {
  val slug = "warmup"

  def generateCourse() = {
    val area = RaceArea((500, 800), (-500, -100))
    Course(
      upwind = Gate(600, 100),
      downwind = Gate(100, 100),
      laps = 3,
      islands = Nil,
      area = area,
      windGenerator = WindGenerator.spawn(3, 3, 2, 2),
      gustGenerator = GustGenerator(30, Seq.fill[GustDef](10)(GustDef.spawn))
    )
  }
}

object Classic extends CourseGenerator {
  val slug = "classic"

  def generateCourse() = {
    val width = 1400
    val height = 2000
    val area = RaceArea((width/2, height + 200), (-width/2,-300))
    Course(
      upwind = Gate(height, 200),
      downwind = Gate(100, 200),
      laps = 2,
      islands = Seq.fill[Island](5)(Island.spawn(area)),
      area = area,
      windGenerator = WindGenerator.spawn(),
      gustGenerator = GustGenerator.spawn()
    )
  }
}

object Inlands extends CourseGenerator {
  val slug = "inlands"

  def generateCourse() = Course(
    upwind = Gate(2500, 200),
    downwind = Gate(100, 200),
    laps = 2,
    islands = Nil,
    area = RaceArea((500, 2700), (-500, -200)),
    windGenerator = WindGenerator.spawn(6, 4, 6, 4),
    gustGenerator = GustGenerator(interval = 10, Seq.fill[GustDef](30)(GustDef.spawn))
  )
}

object Archipel extends CourseGenerator {
  val slug = "archipel"

  def generateCourse() = {
    val area = RaceArea((1000, 5500), (-1000, -200))
    Course(
      upwind = Gate(5000, 200),
      downwind = Gate(100, 200),
      laps = 1,
      islands = Seq.fill(100)(Island((area.randomX(600), area.randomY(600)), Random.nextInt(50) + 50)),
      area = area,
      windGenerator = WindGenerator.spawn(4, 4, 6, 6),
      gustGenerator = GustGenerator(interval = 30, Seq.fill[GustDef](10)(GustDef.spawn))
    )
  }
}

object Grid extends CourseGenerator {
  val slug = "grid"

  def generateCourse() = {
    val upwind = Gate(1600, 200)
    val downwind = Gate(100, 200)
    val area = RaceArea((800, upwind.y + 500), (-800, downwind.y - 300))

    val r = 30

    val islands = for {
      i <- 1.to(7)
      j <- 1.to(6)
      x = i * 200 + area.left + Random.nextInt(r) - r/2
      y = j * 200 + downwind.y + Random.nextInt(r) - r/2
      radius = 50 + Random.nextInt(20)
    }
    yield Island((x, y), radius)

    Course(
      upwind = upwind,
      downwind = downwind,
      laps = 2,
      islands = islands,
      area = area,
      windGenerator = WindGenerator.spawn(4, 3, 2, 1),
      gustGenerator = GustGenerator(interval = 30, Seq.fill[GustDef](10)(GustDef.spawn))
    )
  }
}

object OysterPark extends CourseGenerator {
  val slug = "oysterpark"

  def generateCourse() = {
    val upwind = Gate(1800, 250)
    val downwind = Gate(100, 250)
    val area = RaceArea((750, upwind.y + 500), (-750, downwind.y - 300))

    val islands = for {
      i <- 1.to(5)
      j <- 1.to(40)
      x = i * 250 + area.left + (i * Math.PI * 100) % 100 - 50
      y = j * 40 + downwind.y
      radius = 15
    }
    yield if ((j + i) % 5 == 0) None else Some(Island((x, y), radius))

    Course(
      upwind = upwind,
      downwind = downwind,
      laps = 2,
      islands = islands.flatten,
      area = area,
      windGenerator = WindGenerator.spawn(3, 3, 2, 2),
      gustGenerator = GustGenerator(interval = 20, Seq.fill[GustDef](15)(GustDef.spawn))
    )
  }
}

object Minefield extends CourseGenerator {
  val slug = "minefield"

  def generateCourse() = {
    val upwind = Gate(5100, 400)
    val downwind = Gate(100, 400)
    val area = RaceArea((800, upwind.y + 500), (-800, downwind.y - 300))

    val r = 60

    val islands = for {
      i <- 1.to(7)
      j <- 1.to(15)
      x = i * 200 + area.left + Random.nextInt(r) - r/2
      y = j * 200 + downwind.y + Random.nextInt(r) - r/2 + 600
      radius = 40 + Random.nextInt(40)
    }
    yield Island((x, y), radius)

    Course(
      upwind = upwind,
      downwind = downwind,
      laps = 1,
      islands = islands,
      area = area,
      windGenerator = WindGenerator.spawn(5, 5, 3, 3),
      gustGenerator = GustGenerator(interval = 15, Seq.fill[GustDef](10)(GustDef.spawn))
    )
  }
}


object CourseGenerator {

  val all = Seq(Classic, WarmUp, Inlands)

  def findBySlug(slug: String): Option[CourseGenerator] = all.find(_.slug == slug)

  def ensureTimeTrials() = {
    val period = TimeTrial.currentPeriod
    all.foreach { t =>
      Track.findBySlug(t.slug).map {
        case Some(_) =>
        case None => {
          val track = Track(
            _id = reactivemongo.bson.BSONObjectID.generate,
            slug = t.slug,
            course = t.generateCourse(),
            countdown = 30,
            startCycle = 60
          )
          Track.save(track)
        }
      }
      TimeTrial.findBySlugAndPeriod(t.slug, period).map {
        case Some(_) =>
        case None => {
          play.Logger.info(s"time trial '${t.slug}' not found for period $period, creating...")
          val trial = TimeTrial(slug = t.slug, course = t.generateCourse(), period = period)
          TimeTrial.save(trial)
        }
      }
    }
  }

}
