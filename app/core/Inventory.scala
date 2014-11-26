package core

import models._
import play.api.libs.concurrent.Execution.Implicits._

import scala.util.Random

object Inventory {

  val simple = TimeTrial(
    slug = "simple",
    course = Course(
      upwind = Gate(500, 200),
      downwind = Gate(0, 200),
      laps = 1,
      markRadius = 5,
      islands = Nil,
      area = RaceArea((800, 700), (-800, -300)),
      windGenerator = WindGenerator(6, 6, 4, 4),
      gustGenerator = GustGenerator(10, Nil)
    ),
    countdownSeconds = 10
  )

  val classic = TimeTrial(
    slug = "classic",
    course = Course(
      upwind = Gate(2500, 200),
      downwind = Gate(0, 200),
      laps = 2,
      markRadius = 5,
      islands = Seq(
        Island((-200, 600), 100),
        Island((-200, 400), 100),
        Island((300, 700), 150)
      ),
      area = RaceArea((700, 2700), (-700, -300)),
      windGenerator = WindGenerator(8, 6, 4, 8),
      gustGenerator = GustGenerator(20, Seq.fill[GustDef](10)(GustDef.spawn))
    )
  )

  val manyLaps = TimeTrial(
    slug = "manyLaps",
    course = Course(
      upwind = Gate(500, 100),
      downwind = Gate(0, 100),
      laps = 4,
      markRadius = 5,
      islands = Nil,
      area = RaceArea((500, 700), (-500, -300)),
      windGenerator = WindGenerator(1, 1, 1, 1),
      gustGenerator = GustGenerator(30, Seq.fill[GustDef](10)(GustDef.spawn))
    )
  )

  val archipel = {
    val area = RaceArea((1000, 5500), (-1000, -300))
    TimeTrial(
      slug = "archipel",
      course = Course(
        upwind = Gate(5000, 200),
        downwind = Gate(0, 200),
        laps = 1,
        markRadius = 5,
        islands = Seq.fill(100)(Island((area.randomX(300), area.randomY(500)), Random.nextInt(50) + 50)),
        area = area,
        windGenerator = WindGenerator(2, 4, 10, 8),
        gustGenerator = GustGenerator(30, Seq.fill[GustDef](10)(GustDef.spawn))
      )
    )
  }

  val all = Seq(simple, classic, manyLaps, archipel)

  def createTimeTrials() = {
    all.foreach { t =>
      TimeTrial.findBySlug(t.slug).map {
        case Some(_) =>
        case None => TimeTrial.save(t)
      }
    }
  }

}
