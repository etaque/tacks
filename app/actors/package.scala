import java.util.UUID
import akka.actor._
import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._
import play.api.Play.current

import models._
import dao._


package object actors {

  def trackMeta(track: Track): Future[TrackMeta] = {
    for {
      creator <- Users.findById(track.creatorId)
      rankings <- playerRankings(track.id)
      runsCount <- Runs.countForTrack(track.id)
    }
    yield TrackMeta(creator.getOrElse(sys.error("TODO join")), rankings, runsCount.toLong)
  }

  def playerRankings(trackId: UUID): Future[Seq[PlayerRanking]] = {
    for {
      runRankings <- Runs.extractRankings(trackId)
      players <- Users.listByIds(runRankings.map(_.playerId))
      playerRankings = runRankings.flatMap { r =>
        players.find(_.id == r.playerId).map(p => PlayerRanking(r.rank, r.runId, p, r.duration))
      }
    }
    yield playerRankings
  }
}
