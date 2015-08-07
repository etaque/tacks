import actors.RacesSupervisor
import core.{WarmUp, Classic, CourseGenerator}
import models._
import dao._
import org.joda.time.DateTime
import play.api.{Application, GlobalSettings}
import reactivemongo.bson.BSONObjectID
import scala.concurrent.duration._
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._

object Global extends GlobalSettings {
  override def onStart(app: Application) {

    UserDAO.ensureIndexes()
    TrackDAO.ensureIndexes()

    RacesSupervisor.start()

    ensureTracks()
  }

  def ensureTracks() = {
    CourseGenerator.all.foreach { gen =>
      TrackDAO.findBySlug(gen.slug).map {
        case Some(_) => // do nothing
        case None => {
          val rc = Track(BSONObjectID.generate, gen.slug, gen.generateCourse(), 30, 60)
          TrackDAO.save(rc)
        }
      }
    }
  }

}
