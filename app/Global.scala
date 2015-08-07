import actors.RacesSupervisor
import core.{WarmUp, Classic, CourseGenerator}
import models._
import org.joda.time.DateTime
import play.api.{Application, GlobalSettings}
import reactivemongo.bson.BSONObjectID
import scala.concurrent.duration._
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._

object Global extends GlobalSettings {
  override def onStart(app: Application) {

    User.ensureIndexes()
    TimeTrial.ensureIndexes()
    Track.ensureIndexes()

    RacesSupervisor.start()

    ensureTracks()

    val trialsFreq = if (play.Play.isDev) 5.seconds else 1.hour
    Akka.system.scheduler.schedule(10.seconds, trialsFreq)(CourseGenerator.ensureTimeTrials())

    genData()
  }

  def ensureTracks() = {

    CourseGenerator.all.foreach { gen =>
      Track.findBySlug(gen.slug).map {
        case Some(_) => // do nothing
        case None => {
          val rc = Track(BSONObjectID.generate, gen.slug, gen.generateCourse(), 30, 60)
          Track.save(rc)
        }
      }
    }

  }

  def genData() = {

    Tournament.count.foreach { count =>

      if (count == 0) {

        val handle = "user-" + DateTime.now.getMillis
        val user = User(BSONObjectID.generate, handle + "@email.com", handle, None, None)

        val t = Tournament(
          _id = BSONObjectID.generate,
          masterId = user.id,
          name = "Tournoi de test",
          meetTime = Some(DateTime.now.minusDays(1)),
          description = None,
          state = TournamentState.finished
        )

        val p1 = BSONObjectID.generate
        val p2 = BSONObjectID.generate

        val r1 = Race(
          playerId = None,
          tournamentId = Some(t.id),
          course = Classic.generateCourse(),
          generator = Classic.slug,
          startTime = Some(DateTime.now.minusHours(4)),
          finished = true,
          rankings = Seq(
            RaceRanking(1, p1, Some("player1"), 2000, 3),
            RaceRanking(2, p2, Some("player2"), 2004, 2),
            RaceRanking(3, user.id, user.handleOpt, 2009, 1)
          )
        )

        val r2 = Race(
          playerId = None,
          tournamentId = Some(t.id),
          course = WarmUp.generateCourse(),
          generator = WarmUp.slug,
          startTime = Some(DateTime.now.minusDays(1)),
          finished = true,
          rankings = Seq(
            RaceRanking(1, p2, Some("player2"), 2004, 2),
            RaceRanking(2, user.id, user.handleOpt, 2009, 1)
          )
        )

        val r3 = Race(
          playerId = None,
          tournamentId = Some(t.id),
          course = WarmUp.generateCourse(),
          generator = WarmUp.slug,
          startTime = Some(DateTime.now.minusDays(1)),
          finished = true,
          rankings = Seq(
            RaceRanking(1, p1, Some("player1"), 2004, 3),
            RaceRanking(2, user.id, user.handleOpt, 2009, 2),
            RaceRanking(3, p2, Some("player2"), 2006, 1)
          )
        )

        for {
          _ <- User.save(user)
          _ <- Tournament.save(t)
          _ <- Race.save(r1)
          _ <- Race.save(r2)
          _ <- Race.save(r3)
          _ <- Race.save(r3.copy(_id = BSONObjectID.generate))
        }
        yield ()

      }

    }

  }
}
