package models

import org.joda.time.{LocalDate, DateTime}
import reactivemongo.bson._

case class Run(
  _id: BSONObjectID = BSONObjectID.generate,
  trackId: BSONObjectID,
  raceId: BSONObjectID,
  playerId: BSONObjectID,
  playerHandle: Option[String] = None,
  startTime: DateTime,
  tally: Seq[Long],
  finishTime: Long
) extends HasId with WithPlayer {
  def creationTime = idTime
}


case class RunPath(
  _id: BSONObjectID = BSONObjectID.generate,
  runId: BSONObjectID,
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
    RunPath(BSONObjectID.generate, BSONObjectID.generate, Map(s -> Seq(p)))
  }
}

case class PathPoint(
  ms: Int,
  p: Geo.Point,
  h: Double
)

