import actors.RacesSupervisor
import models.User
import play.api.{Application, GlobalSettings}

object Global extends GlobalSettings {
  override def onStart(app: Application) {

    User.ensureIndexes()

    RacesSupervisor.start()
  }
}
