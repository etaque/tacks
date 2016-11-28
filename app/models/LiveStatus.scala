package models

import java.util.UUID
import actors._
import scala.concurrent.Future
import scala.concurrent.duration._
import akka.pattern.{ ask, pipe }
import akka.util.Timeout
import play.api.libs.concurrent.Execution.Implicits._

case class LiveStatus(
  liveTracks: Seq[LiveTrack],
  liveTimeTrial: Option[LiveTimeTrial],
  onlinePlayers: Seq[Player]
)

case class LiveTimeTrial(
  timeTrial: TimeTrial,
  track: Track,
  meta: TrackMeta
)

object LiveStatus {

  implicit val timeout = Timeout(1.second)

  def get(): Future[LiveStatus] = {
    val tracksFu = getLiveTracks
    val timeTrialFu = getLiveTimeTrial(None)
    val onlinePlayersFu = getOnlinePlayers
    for {
      tracks <- tracksFu
      timeTrial <- timeTrialFu
      onlinePlayers <- onlinePlayersFu
    }
    yield LiveStatus(tracks, timeTrial, onlinePlayers)
  }

  def getLiveTracks(): Future[Seq[LiveTrack]] = {
    (RacesSupervisor.actorRef ? SupervisorAction.GetTracks).mapTo[Seq[LiveTrack]].map { liveTracks =>
      liveTracks.filter(_.track.isOpen).sortBy(_.meta.rankings.length).reverse
    }
  }

  def getLiveTimeTrial(period: Option[String] = None): Future[Option[LiveTimeTrial]] = {
    dao.TimeTrials.findByPeriodWithTrack(period.getOrElse(TimeTrial.currentPeriod())).flatMap {
      case Some((trial, track)) =>
        trackMeta(track, Some(trial)).map(LiveTimeTrial(trial, track, _)).map(Some(_))

      case None =>
        Future.successful(None)
    }
  }

  def getOnlinePlayers(): Future[Seq[Player]] = {
    (LiveCenter.actorRef ? GetOnlinePlayers).mapTo[Seq[Player]]
  }

  def trackMeta(track: Track, timeTrial: Option[TimeTrial] = None): Future[TrackMeta] = {
    for {
      creator <- dao.Users.findById(track.creatorId)
      rankings <- trackPlayerRankings(track.id, timeTrial.map(_.id))
      runsCount <- dao.Runs.countForTrack(track.id)
    }
    yield TrackMeta(creator.getOrElse(sys.error("TODO join")), rankings, runsCount.toLong)
  }

  def trackPlayerRankings(trackId: UUID, timeTrialId: Option[UUID] = None): Future[Seq[PlayerRanking]] = {
    for {
      runRankings <- dao.Runs.extractRankings(trackId, timeTrialId)
      players <- dao.Users.listByIds(runRankings.map(_.playerId))
      playerRankings = runRankings.flatMap { r =>
        players.find(_.id == r.playerId).map(p => PlayerRanking(r.rank, r.runId, p, r.duration))
      }
    }
    yield playerRankings
  }
}
