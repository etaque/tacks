import akka.actor._
import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._
import play.api.Play.current

import reactivemongo.bson.BSONObjectID

import models._
import dao._

package object actors {

  case class PlayerContext(
    player: Player,
    input: KeyboardInput,
    state: OpponentState,
    ref: ActorRef
  ) {
    def asOpponent = Opponent(state, player)
  }

  case class PlayerJoin(player: Player)
  case class PlayerQuit(player: Player)

  case object FrameTick
  case object SpawnGust
  case object GetStatus
  case object AutoClean

  def trackMeta(track: Track): Future[TrackMeta] = {
    for {
      creator <- UserDAO.findById(track.creatorId)
      rankings <- playerRankings(track.id)
      runsCount <- RunDAO.countForTrack(track.id)
    }
    yield TrackMeta(creator, rankings, runsCount)
  }

  def playerRankings(trackId: BSONObjectID): Future[Seq[PlayerRanking]] = {
    for {
      runRankings <- RunDAO.extractRankings(trackId)
      players <- UserDAO.listByIds(runRankings.map(_.playerId))
      playerRankings = runRankings.flatMap(r => players.find(_.id == r.playerId).map(p => PlayerRanking(r.rank, p, r.finishTime)))
    }
    yield playerRankings
  }
}
