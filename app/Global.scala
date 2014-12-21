import actors.RacesSupervisor
import core.TrialGenerator
import models.{TimeTrial, User}
import play.api.{Application, GlobalSettings}
import scala.concurrent.duration._
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._

object Global extends GlobalSettings {
  override def onStart(app: Application) {

    User.ensureIndexes()
    TimeTrial.ensureIndexes()

    RacesSupervisor.start()

    val trialsFreq = if (play.Play.isDev) 5.seconds else 1.hour
    Akka.system.scheduler.schedule(10.seconds, trialsFreq)(TrialGenerator.ensureTimeTrials())
  }
}
