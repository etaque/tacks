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
          gustGenerator = GustGenerator(10, Nil)
        ),
        countdownSeconds = 10
      ),

      TimeTrial(
        slug = "classic",
        course = Course(
          upwind = Gate(2500, 200),
          downwind = Gate(0, 200),
          laps = 2,
          markRadius = 5,
          islands = Seq(
            Island((-200, 300), 100),
            Island((300, 700), 150)
          ),
          area = RaceArea((600, 2700), (-600, -300)),
          windGenerator = WindGenerator(8, 6, 4, 8),
          gustGenerator = GustGenerator(20, Seq(
            GustDef(-5, 5, 200),
            GustDef(5, 2, 300),
            GustDef(0, -2, 100)
          ))
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
