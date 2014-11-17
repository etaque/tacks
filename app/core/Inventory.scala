package core

import models._
import play.api.libs.concurrent.Execution.Implicits._

object Inventory {

  def createTimeTrials() = {
    val trials = Seq(
      TimeTrial(
        slug = "test",
        course = Course(
          upwind = Gate(2000, 100),
          downwind = Gate(0, 100),
          laps = 2,
          markRadius = 5,
          islands = Seq(
            Island((0, 500), 100),
            Island((0, 1000), 100),
            Island((0, 1500), 100)
          ),
          area = RaceArea((800, 2200), (-800, -300)),
          windGenerator = WindGenerator(6, 6, 4, 4),
          gustsCount = 5

        ),
        countdownSeconds = 60
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
