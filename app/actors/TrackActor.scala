package actors

import scala.concurrent.duration._
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import akka.actor._
import reactivemongo.bson.BSONObjectID
import org.joda.time.DateTime

import models._
import tools.Conf

case class TrackState(
  track: Track,
  nextRace: Option[Race],
  liveRaces: Seq[Race]
) {
  def raceLeaderboard(raceId: BSONObjectID): Seq[PlayerTally] = {
    liveRaces.find(_.id == raceId).map(_.leaderboard).getOrElse(Nil)
  }

  def playerRace(playerId: BSONObjectID): Option[Race] = {
    liveRaces.find(_.playerIds.contains(playerId)).orElse(nextRace)
  }

  def withUpdatedRace(race: Race): TrackState = {
    if (nextRace.map(_.id).contains(race.id)) copy(nextRace = Some(race))
    else liveRaces.indexWhere(_.id == race.id) match {
      case -1 => this
      case i => copy(liveRaces = liveRaces.updated(i, race))
    }
  }

  def escapePlayer(playerId: BSONObjectID): TrackState = {
    copy(
      nextRace = nextRace.map(_.removePlayerId(playerId)),
      liveRaces = liveRaces.map(_.removePlayerId(playerId))
    )
  }
}

case object RotateNextRace

class TrackActor(track: Track) extends Actor with ManageWind {

  val id = BSONObjectID.generate
  val course = track.course

  var state = TrackState(
    track = track,
    nextRace = None,
    liveRaces = Nil
  )

  val players = scala.collection.mutable.Map[String, PlayerContext]()

  def clock: Long = DateTime.now.getMillis

  val ticks = Seq(
    Akka.system.scheduler.schedule(1.second, 1.second, self, RotateNextRace),
    Akka.system.scheduler.schedule(0.seconds, course.gustGenerator.interval.seconds, self, SpawnGust),
    Akka.system.scheduler.schedule(0.seconds, Conf.frameMillis.milliseconds, self, FrameTick)
  )

  def receive = {

    /**
     * player join => added to context Map
     */
    case PlayerJoin(player) => {
      players += player.id.stringify -> PlayerContext(player, KeyboardInput.initial, OpponentState.initial, sender())
    }

    /**
     * player quit => removed from context Map
     */
    case PlayerQuit(player) => {
      players -= player.id.stringify
    }

    /**
     * game heartbeat:
     * update wind (origin, speed and gusts positions)
     */
    case FrameTick => {
      updateWind()
    }

    /**
     * player update coming from websocket through player actor
     * context is updated, race started if requested
     */
    case PlayerUpdate(player, PlayerInput(opState, input, clientTime)) => {
      val id = player.id.stringify

      players.get(id).foreach { context =>
        val newContext = context.copy(input = input, state = opState)
        players += (id -> newContext)

        if (input.startCountdown) {
          state = TrackActor.startCountdown(state, byPlayerId = player.id)
        }

        if (input.escapeRace) {
          state = state.escapePlayer(player.id)
        }

        if (context.state.crossedGates != newContext.state.crossedGates) {
          state = TrackActor.gateCrossedUpdate(state, newContext, players.toMap)
        }

        context.ref ! raceUpdateForPlayer(player, clientTime)
      }
    }

    /**
     * new gust
     */
    case SpawnGust => generateGust()

    case RotateNextRace => {
      state = TrackActor.rotateNextRace(state)
    }

    case GetStatus => {
      sender ! (state.nextRace, players.values.map(_.asOpponent))
    }
  }

  def playerOpponents(playerId: String): Seq[Opponent] = {
    players.toSeq.filterNot(_._1 == playerId).map(_._2.asOpponent)
  }

  def playerLeaderboard(playerId: String): Seq[PlayerTally] = {
    state.playerRace(BSONObjectID(playerId)).map(_.id).map(state.raceLeaderboard).getOrElse(Nil)
  }

  def raceUpdateForPlayer(player: Player, clientTime: Long) = {
    RaceUpdate(
      serverNow = DateTime.now,
      startTime = TrackActor.playerStartTime(state, player),
      wind = wind,
      opponents = playerOpponents(player.id.stringify),
      leaderboard = playerLeaderboard(player.id.stringify),
      clientTime = clientTime
    )
  }

  override def postStop() = {
    ticks.foreach(_.cancel())
  }
}

object TrackActor {
  def props(track: Track) = Props(new TrackActor(track))

  def rotateNextRace(state: TrackState): TrackState = {
    state.nextRace match {
      case Some(nextRace) if nextRace.startTime.plusSeconds(state.track.countdown).isBeforeNow => {
        state.copy(nextRace = None, liveRaces = state.liveRaces :+ nextRace)
      }
      case _ => state
    }
  }

  def playerStartTime(state: TrackState, player: Player): Option[DateTime] = {
    state.playerRace(player.id).map(_.startTime)
  }

  def gateCrossedUpdate(state: TrackState, context: PlayerContext, players: Map[String,PlayerContext]): TrackState = {
    state.playerRace(context.player.id).map { race =>

      val playerIds =
        if (context.state.crossedGates.length == 1) race.playerIds :+ context.player.id
        else race.playerIds

      val leaderboard = playerIds.map(_.stringify).flatMap(players.get).map { context =>
        PlayerTally(context.player.id, context.player.handleOpt, context.state.crossedGates)
      }.sortBy { pt =>
        (-pt.gates.length, pt.gates.headOption)
      }

      val updatedRace = race.copy(playerIds = playerIds, leaderboard = leaderboard)

      state.withUpdatedRace(updatedRace)

    }.getOrElse(state)
  }

  def startCountdown(state: TrackState, byPlayerId: BSONObjectID): TrackState = {
    state.nextRace match {
      case None => {
        val race = Race(
          _id = BSONObjectID.generate,
          trackId = state.track.id,
          startTime = DateTime.now.plusSeconds(state.track.countdown),
          playerIds = Nil,
          leaderboard = Nil
        )
        state.copy(nextRace = Some(race))
      }
      case Some(_) => state
    }
  }
}
