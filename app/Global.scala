import actors.RacesSupervisor
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

    // UserDAO.ensureIndexes()
    // TrackDAO.ensureIndexes()

    RacesSupervisor.start()
  }
}
