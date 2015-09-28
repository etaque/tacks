package models

import org.joda.time.{LocalDate, DateTime}
import reactivemongo.bson._

case class Race(
  _id: BSONObjectID,
  trackId: BSONObjectID,
  startTime: DateTime,
  players: Set[Player],
  tallies: Seq[PlayerTally]
) extends HasId {

  def hasPlayer(playerId: BSONObjectID): Boolean =
    players.exists(_.id == playerId)

  def removePlayerId(id: BSONObjectID): Race =
    copy(
      players = players.filterNot(_.id == id),
      tallies = tallies.filterNot(t => t.player.id == id && !t.finished)
    )
}

case class PlayerTally(
  player: Player,
  gates: Seq[Long],
  finished: Boolean
)
