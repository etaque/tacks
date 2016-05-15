package models

import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._
import java.util.UUID
import org.joda.time.{LocalDate, DateTime}

case class RaceReport(
  id: UUID,
  startTime: DateTime,
  trackId: UUID,
  trackName: String,
  runs: Seq[Run]
)

object RaceReport {
  def list(count: Int, minPlayers : Option[Int], trackId: Option[UUID]): Future[Seq[RaceReport]] = {
    for {
      raceIds <- dao.Runs.lastRaceIds(count, minPlayers, trackId)
      runs <- dao.Runs.listForRaces(raceIds)
      tracks <- dao.Tracks.list()
      reports = runs.groupBy(_.raceId).flatMap { case (raceId, runs) =>
        for {
          firstRun <- runs.headOption
          track <- tracks.find(_.id == firstRun.trackId)
        } yield RaceReport(raceId, firstRun.startTime, track.id, track.name, runs)
      }.toSeq.sortBy(_.startTime.getMillis * -1)
    } yield
      reports
  }
}
