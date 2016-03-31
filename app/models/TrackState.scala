package models

import java.util.UUID
import akka.actor.ActorRef
import org.joda.time.DateTime
import models._
import tools.Conf


case class TrackState(
  track: Track,
  races: Seq[Race],
  players: Map[PlayerId, PlayerContext],
  paths: Map[PlayerId, RunPath],
  playersGhosts: Map[PlayerId, Map[RunId, GhostState]],
  ghostRuns: Map[RunId, (Run, RunPath)]
) {

  def reloadTrack(track: Track): TrackState = {
    copy(track = track)
  }

  def addPlayer(player: Player, ref: ActorRef): TrackState = {
    val ctx = PlayerContext(player, OpponentState.initial, ref)
    copy(players = players + (player.id -> ctx))
  }

  def updatePlayer(playerId: PlayerId, ctx: PlayerContext, clock: Long): TrackState = {
    val withCtx = copy(players = players + (playerId -> ctx))
    playerRace(playerId).map { race =>
      if (track.status == TrackStatus.open && race.startTime.plusMinutes(10).isAfterNow) { // max 10min de trace

        val elapsedMillis = clock - race.startTime.getMillis
        val currentSecond = elapsedMillis / 1000

        val p = PathPoint((elapsedMillis % 1000).toInt, ctx.state.position, ctx.state.heading)

        val newPath = paths.get(playerId)
          .map(_.addPoint(currentSecond, p))
          .getOrElse(RunPath.init(currentSecond, p))

        withCtx.copy(paths = paths + (playerId -> newPath))
      } else {
        withCtx
      }
    }.getOrElse(withCtx)
  }

  def gateCrossedUpdate(context: PlayerContext): TrackState = {
    playerRace(context.player.id).map { race =>

      val players = race.players + context.player

      val finished = context.state.hasFinished(track.course)
      val newTally = PlayerTally(context.player, context.state.crossedGates, finished)

      val tallies = race.tallies
        .filter(_.player.id != context.player.id) :+ newTally

      val sortedTallies = tallies.sortBy { t =>
        (-t.gates.length, t.gates.headOption)
      }

      val updatedRace = race.copy(players = players, tallies = tallies)

      updateRace(updatedRace)
    }.getOrElse(this)
  }

  def removePlayer(player: Player): TrackState = {
    copy(
      players = players - player.id,
      paths = paths - player.id
    )
  }

  def startCountdown(byPlayerId: PlayerId): TrackState = {
    races.headOption match {
      case Some(race) if !race.isClosed() =>
        this

      case _ =>
        val newRace = Race(
          id = UUID.randomUUID(),
          trackId = track.id,
          startTime = DateTime.now.plusSeconds(Conf.countdown),
          players = Set.empty,
          tallies = Nil
        )
        copy(races = newRace +: races)
    }
  }

  def addGhost(player: Player, run: Run, path: RunPath): TrackState = {
    val all = playersGhosts.getOrElse(player.id, Map.empty)
    val g = GhostState.initial(run.playerId, run.playerHandle, run.tally)
    copy(
      playersGhosts = playersGhosts + (player.id -> (all + (run.id -> g))),
      ghostRuns = ghostRuns + (run.id -> (run, path))
    )
  }

  def removeGhost(player: Player, runId: RunId): TrackState = {
    playersGhosts.get(player.id).map { runIds =>
      copy(playersGhosts = playersGhosts + (player.id -> (runIds - runId)))
    }.getOrElse(this)
  }

  def updateRace(race: Race): TrackState = {
    races.indexWhere(_.id == race.id) match {
      case -1 => this
      case i => copy(races = races.updated(i, race))
    }
  }

  def escapePlayer(playerId: PlayerId): TrackState = {
    copy(
      races = races.map(_.removePlayerId(playerId))
    )
  }

  def cleanStaleRaces(): TrackState = {
    copy(
      races = races.filterNot(_.isStale())
    )
  }

  def playerRace(playerId: PlayerId): Option[Race] = {
    races.find(_.hasPlayer(playerId)).orElse(races.headOption)
  }

  def playerStartTime(player: Player): Option[DateTime] = {
    playerRace(player.id).map(_.startTime)
  }

  def playerOpponents(playerId: PlayerId): Seq[Opponent] = {
    players.toSeq.filterNot(_._1 == playerId).map(_._2.asOpponent)
  }

  def playerGhosts(playerId: PlayerId)(ts: Long): Seq[GhostState] = {
    playersGhosts.get(playerId).map { runIds =>
      runIds.toSeq.flatMap { case (runId, ghostState) =>
        ghostRuns.get(runId).map { case (_, path) =>
          GhostState.at(ts, path)(ghostState)
        }
      }
    }.getOrElse(Nil)
  }

  def playerTallies(playerId: PlayerId): Seq[PlayerTally] = {
    playerRace(playerId).map(_.id).map(raceTallies).getOrElse(Nil)
  }

  def raceTallies(raceId: UUID): Seq[PlayerTally] = {
    races.find(_.id == raceId).map(_.tallies).getOrElse(Nil)
  }

  def listPlayers: Seq[Player] = {
    players.values.map(_.player).toSeq
  }
}

case class PlayerContext(
  player: Player,
  state: OpponentState,
  ref: ActorRef
) {
  def asOpponent = Opponent(state, player)
}

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

  def isClosed(): Boolean =
    startTime.plusSeconds(tools.Conf.countdown).isBeforeNow

  def isStale(): Boolean =
    isClosed() && players.isEmpty
}

case class PlayerTally(
  player: Player,
  gates: Seq[Long],
  finished: Boolean
)
