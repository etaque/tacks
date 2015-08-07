package models

import org.joda.time.{LocalDate, DateTime}
import reactivemongo.bson._

case class Track(
  _id: BSONObjectID,
  slug: String,
  course: Course,
  countdown: Int,
  startCycle: Int
) extends HasId

case class Race(
  _id: BSONObjectID,
  trackId: BSONObjectID,
  startTime: DateTime,
  playerIds: Seq[BSONObjectID],
  leaderboard: Seq[PlayerTally]
) extends HasId {
  def removePlayerId(id: BSONObjectID): Race = {
    copy(playerIds = playerIds.filterNot(_ == id))
  }
}

case class PlayerTally(
  playerId: BSONObjectID,
  playerHandle: Option[String],
  gates: Seq[Long]
) extends WithPlayer

case class Run(
  _id: BSONObjectID = BSONObjectID.generate,
  trackId: BSONObjectID,
  raceId: BSONObjectID,
  playerId: BSONObjectID,
  playerHandle: Option[String] = None,
  startTime: DateTime,
  tally: Seq[Long] = Nil,
  finishTime: Option[Long] = None
) extends HasId with WithPlayer {
  def creationTime = idTime
}

// case class RunRanking(
//   rank: Int,
//   playerId: BSONObjectID,
//   playerHandle: Option[String],
//   runId: BSONObjectID,
//   finishTime: Long
// ) extends WithPlayer {
//   def creationTime = new DateTime(runId.time)
//   def isRecent = creationTime.plusDays(1).isAfterNow
// }
