package core

import models._
import play.api.libs.concurrent.Execution.Implicits._

import scala.util.Random

object Inventory {

  val warmup = TimeTrial(
    slug = "warmup",
    course = Course(
      upwind = Gate(600, 100),
      downwind = Gate(100, 100),
      laps = 4,
      markRadius = 5,
      islands = Seq(Island((200, 400), 40), Island((-200, 300), 60)),
      area = RaceArea((500, 700), (-500, -100)),
      windGenerator = WindGenerator(1, 1, 1, 1),
      gustGenerator = GustGenerator(30, Seq.fill[GustDef](10)(GustDef.spawn))
    )
  )

  val gusty = TimeTrial(
    slug = "gusty",
    course = Course(
      upwind = Gate(2500, 200),
      downwind = Gate(100, 200),
      laps = 2,
      markRadius = 5,
      islands = Nil,
      area = RaceArea((600, 2700), (-600, -200)),
      windGenerator = WindGenerator(8, 6, 4, 8),
      gustGenerator = GustGenerator(10, Seq.fill[GustDef](30)(GustDef.spawn))
    )
  )

  val archipel = {
    val area = RaceArea((1000, 5500), (-1000, -200))
    TimeTrial(
      slug = "archipel",
      course = Course(
        upwind = Gate(5000, 200),
        downwind = Gate(100, 200),
        laps = 1,
        markRadius = 5,
        islands = Seq.fill(100)(Island((area.randomX(300), area.randomY(500)), Random.nextInt(50) + 50)),
        area = area,
        windGenerator = WindGenerator(2, 4, 10, 8),
        gustGenerator = GustGenerator(30, Seq.fill[GustDef](10)(GustDef.spawn))
      )
    )
  }

  val all = Seq(warmup, gusty, archipel)

  def createTimeTrials() = {
    all.foreach { t =>
      TimeTrial.findBySlug(t.slug).map {
        case Some(_) =>
        case None => TimeTrial.save(t)
      }
    }
  }

}
