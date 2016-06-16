package models

import actors._
import scala.concurrent.Future
import scala.concurrent.duration._
import akka.pattern.{ ask, pipe }
import akka.util.Timeout
import play.api.libs.concurrent.Execution.Implicits._

case class LiveStatus(
  liveTracks: Seq[LiveTrack],
  onlinePlayers: Seq[Player]
)

object LiveStatus {

  implicit val timeout = Timeout(1.second)

  def get(): Future[LiveStatus] = {
    val tracksFu = (RacesSupervisor.actorRef ? SupervisorAction.GetTracks).mapTo[Seq[LiveTrack]]
    val onlinePlayersFu = (LiveCenter.actorRef ? GetOnlinePlayers).mapTo[Seq[Player]]
    for {
      tracks <- tracksFu
      homeLiveTracks = tracks.filter(_.track.isOpen).sortBy(_.meta.rankings.length).reverse
      onlinePlayers <- onlinePlayersFu
    }
    yield LiveStatus(homeLiveTracks, onlinePlayers)
  }
}
