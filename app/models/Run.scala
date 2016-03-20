package models

import java.util.UUID
import org.joda.time.{LocalDate, DateTime}


case class Run(
  id: UUID = UUID.randomUUID(),
  trackId: UUID,
  raceId: UUID,
  playerId: UUID,
  playerHandle: Option[String] = None,
  startTime: DateTime,
  tally: Seq[Long],
  duration: Long
) extends WithPlayer {
}


case class RunPath(
  id: UUID = UUID.randomUUID(),
  runId: UUID,
  slices: Map[Long,Seq[PathPoint]]
) {
  def addPoint(second: Long, point: PathPoint): RunPath = {
    copy(
      slices = slices.lift(second) match {
        case Some(points) => slices + (second -> (points :+ point))
        case None => slices + (second -> Seq(point))
      }
    )
  }
}

object RunPath {
  def init(s: Long, p: PathPoint): RunPath = {
    RunPath(UUID.randomUUID(), UUID.randomUUID(), Map(s -> Seq(p)))
  }
}

case class PathPoint(
  ms: Int,
  p: Geo.Point,
  h: Double
)

case class RunRanking(
  rank: Long,
  runId: UUID,
  playerId: UUID,
  duration: Long
)
