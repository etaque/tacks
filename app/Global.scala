import actors.RacesSupervisor
import core.Inventory
import models.{TimeTrial, User}
import play.api.{Application, GlobalSettings}

object Global extends GlobalSettings {
  override def onStart(app: Application) {

    User.ensureIndexes()
    TimeTrial.ensureIndexes()

    RacesSupervisor.start()

    Inventory.createTimeTrials()
  }
}
