package core

import models._
import play.api.libs.concurrent.Execution.Implicits._

object Inventory {

  def createTimeTrials() = {
    val trials = Seq(
      TimeTrial(
        slug = "simple",
        course = Course(
          upwind = Gate(500, 200),
          downwind = Gate(0, 200),
          laps = 1,
          markRadius = 5,
          islands = Nil,
          area = RaceArea((800, 700), (-800, -300)),
          windGenerator = WindGenerator(6, 6, 4, 4),
          gustsCount = 0
        ),
        countdownSeconds = 10
      ),

      TimeTrial(
        slug = "classic",
        course = Course(
          upwind = Gate(1500, 200),
          downwind = Gate(0, 200),
          laps = 2,
          markRadius = 5,
          islands = Seq(
            Island((-200, 300), 100),
            Island((300, 700), 150)
          ),
          area = RaceArea((800, 1700), (-800, -300)),
          windGenerator = WindGenerator(8, 6, 4, 8),
          gustsCount = 6
        ),
        countdownSeconds = 30
      )
    )

    trials.foreach { t =>
      TimeTrial.findBySlug(t.slug).map {
        case Some(_) =>
        case None => TimeTrial.save(t)
      }
    }
  }

}
