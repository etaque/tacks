import actors.RacesSupervisor
import play.api.{Application, GlobalSettings}

object Global extends GlobalSettings {
  override def onStart(app: Application) {
    RacesSupervisor.start()
  }
}