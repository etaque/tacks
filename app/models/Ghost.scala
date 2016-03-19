package models

import java.util.UUID
import Geo._


// case class GhostRunContext(
//   currentSecond: Long,
//   currentSlice: Seq[PathPoint]
// )

// case class GhostRunDef(
//   run: Run,
//   path: RunPath
// )

case class GhostState(
  position: Point,
  heading: Double,
  id: UUID,
  handle: Option[String],
  gates: Seq[Long]
) {
  def withPathPoint(pp: PathPoint) =
    copy(position = pp.p, heading = pp.h)
}

object GhostState {
  def initial(id: UUID, handle: Option[String], gates: Seq[Long]) =
  GhostState((0,0), 0, id, handle, gates)

  def at(ts: Long, path: RunPath)(state: GhostState): GhostState = {
    val second = ts / 1000
    val ms = (ts % 1000).toInt
    val pointMaybe = for {
      slice <- path.slices.get(second)
      point <- slice.sortBy(p => math.abs(p.ms - ms)).headOption
    } yield point
    pointMaybe.map(state.withPathPoint).getOrElse(state)
  }
}
