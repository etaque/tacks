package models

import java.util.UUID
import org.joda.time.{LocalDate, DateTime}

case class Race(
  id: UUID,
  trackId: UUID,
  startTime: DateTime,
  players: Set[Player],
  tallies: Seq[PlayerTally]
) {

  def hasPlayer(playerId: UUID): Boolean =
    players.exists(_.id == playerId)

  def removePlayerId(id: UUID): Race =
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
