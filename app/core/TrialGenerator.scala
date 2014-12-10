package core

import models._
import org.joda.time.LocalDate
import play.api.libs.concurrent.Execution.Implicits._

import scala.util.Random

trait TrialGenerator {
  def slug: String
  def generateCourse(): Course
}

object WarmUp extends TrialGenerator {
  val slug = "warmup"

  def generateCourse() = Course(
    upwind = Gate(600, 100),
    downwind = Gate(100, 100),
    laps = 4,
    markRadius = 5,
    islands = Seq(Island((200, 400), 40), Island((-200, 300), 60)),
    area = RaceArea((500, 700), (-500, -100)),
    windGenerator = WindGenerator.spawn(3, 3, 2, 2),
    gustGenerator = GustGenerator(30, Seq.fill[GustDef](10)(GustDef.spawn))
  )
}

object Inlands extends TrialGenerator {
  val slug = "inlands"

  def generateCourse() = Course(
    upwind = Gate(2500, 200),
    downwind = Gate(100, 200),
    laps = 2,
    markRadius = 5,
    islands = Nil,
    area = RaceArea((600, 2700), (-600, -200)),
    windGenerator = WindGenerator.spawn(8, 6, 4, 8),
    gustGenerator = GustGenerator(10, Seq.fill[GustDef](30)(GustDef.spawn))
  )
}

object Archipel extends TrialGenerator {
  val slug = "archipel"

  def generateCourse() = {
    val area = RaceArea((1000, 5500), (-1000, -200))
    Course(
      upwind = Gate(5000, 200),
      downwind = Gate(100, 200),
      laps = 1,
      markRadius = 5,
      islands = Seq.fill(100)(Island((area.randomX(300), area.randomY(500)), Random.nextInt(50) + 50)),
      area = area,
      windGenerator = WindGenerator.spawn(4, 8, 12, 10),
      gustGenerator = GustGenerator(30, Seq.fill[GustDef](10)(GustDef.spawn))
    )
  }
}

object TrialGenerator {

  val all = Seq(WarmUp, Inlands, Archipel)

  def ensureTimeTrials() = {
    val period = TimeTrial.periodKey
    all.foreach { t =>
      TimeTrial.findBySlugAndPeriod(t.slug, period).map {
        case Some(_) =>
        case None => {
          val trial = TimeTrial(slug = t.slug, course = t.generateCourse(), period = period)
          TimeTrial.save(trial)
        }
      }
    }
  }

}
