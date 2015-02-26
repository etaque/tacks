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

case class Start(at: DateTime)
case class PlayerContext(player: Player, input: KeyboardInput, state: OpponentState, ref: ActorRef) {
  def asOpponent = Opponent(state, player)
}

case class RaceState(
  race: Race,
  course: Course,
  master: Option[Player],
  gates: Map[Player, Seq[Long]] = Map.empty,
  leaderboard: Seq[PlayerTally] = Nil,
  finishersCount: Int = 0,
  startTime: Option[DateTime] = None
) {
  def millisBeforeStart: Option[Long] = startTime.map(_.getMillis - DateTime.now.getMillis)
  def startScheduled = startTime.isDefined
  def started = startTime.exists(_.isBeforeNow)
  def clock: Long = DateTime.now.getMillis

  def someFinished = gates.values.exists(_.length == course.gatesToCross)
  def allFinished = gates.nonEmpty && gates.values.forall(_.length == course.gatesToCross)
  def finishers = leaderboard.filter(_.gates.length == course.gatesToCross)

  def rankings: Seq[RaceRanking] = {
    finishers.sortBy(_.gates.headOption).zipWithIndex.map { case (playerState, i) =>
      playerState.gates.headOption.map { time =>
        RaceRanking(i + 1, playerState.playerId, playerState.playerHandle, time, finishers.size - i + 1)
      }
    }.flatten
  }
}


class RaceActor(race: Race, master: Option[Player]) extends Actor with ManageWind {

  val id = race.id
  val course = race.course

  var raceState = RaceState(race, course, master,
    startTime = if (master.isEmpty) Some(DateTime.now.plusSeconds(race.countdownSeconds)) else None)

  type PlayerId = String
  val players = scala.collection.mutable.Map[PlayerId, PlayerContext]()

  def clock: Long = DateTime.now.getMillis

  val ticks = Seq(
    Akka.system.scheduler.schedule(10.seconds, 10.seconds, self, AutoClean),
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
    case PlayerUpdate(player, PlayerInput(state, input, clientTime)) => {
      val id = player.id.stringify

      players.get(id).foreach { context =>
        if (input.startCountdown) {
          raceState = RaceActor.startCountdown(raceState, byPlayerId = player.id)
        }
        players += (id -> context.copy(input = input))
        if (context.state.crossedGates != state.crossedGates) {
          raceState = RaceActor.updateTally(raceState, players.values.map(_.asOpponent).toSeq)
          Race.updateFromState(raceState)
        }
        context.ref ! raceUpdateForPlayer(player, clientTime)
      }
    }

    /**
     * race status, for live center
     */
    case GetStatus => sender ! (raceState.startTime, players.values.map(_.state).toSeq)

    /**
     * new gust
     */
    case SpawnGust => generateGust()

    /**
     * clean obsolete races
     */
    case AutoClean => {
      if (RaceActor.canShutdown(raceState, players.isEmpty, self)) {
        self ! PoisonPill
      }
    }
  }

  def opponentsTo(playerId: String): Seq[Opponent] = {
    players.toSeq.filterNot(_._1 == playerId).map(_._2.asOpponent)
  }

  def raceUpdateForPlayer(player: Player, clientTime: Long) = {
    RaceUpdate(
      serverNow = DateTime.now,
      startTime = raceState.startTime,
      wind = wind,
      opponents = opponentsTo(player.id.stringify),
      leaderboard = raceState.leaderboard,
      isMaster = master.exists(_.id == player.id),
      clientTime = clientTime
    )
  }

  override def postStop() = {
    ticks.foreach(_.cancel())
    players.values.foreach(_.ref ! PoisonPill)
    RaceActor.finishOrRemove(raceState)
  }
}

object RaceActor {
  def props(race: Race, master: Option[Player]) = Props(new RaceActor(race, master))

  def finishOrRemove(raceState: RaceState): Unit = {
    raceState.race.tournamentId match {
      case Some(_) => {
        if (raceState.someFinished) {
          Race.setFinished(raceState.race.id)
        }
      }
      case None => {
        if (raceState.rankings.size >= 2) {
          Race.setFinished(raceState.race.id)
        } else {
          Race.remove(raceState.race.id)
        }
      }
    }
  }

  def startCountdown(state: RaceState, byPlayerId: BSONObjectID): RaceState = {
    if (state.startTime.isEmpty && state.master.exists(_.id == byPlayerId)) {
      val at = DateTime.now.plusSeconds(state.race.countdownSeconds)
      state.copy(startTime = Some(at))
    } else {
      state
    }
  }

  def canShutdown(state: RaceState, isEmpty: Boolean, ref: ActorRef): Boolean = {
    state.race.tournamentId match {
      case Some(_) => state.allFinished
      case None => {
        val deserted = state.master match {
          case Some(_) => isEmpty && state.race.creationTime.plusMinutes(1).isBeforeNow
          case None => isEmpty && state.startTime.exists(_.isBeforeNow)
        }
        val timeout = state.startTime.exists(_.plusMinutes(10).isBeforeNow)
        deserted || timeout
      }
    }
  }

  def updateTally(raceState: RaceState, playerStates: Seq[Opponent]): RaceState = {

    val gates = playerStates.foldLeft(raceState.gates) { (gates, ps) =>
      gates + (ps.player -> ps.state.crossedGates)
    }

    val leaderboard = gates.toSeq.map { case (player, pGates) =>
      PlayerTally(player.id, player.handleOpt, pGates)
    }.sortBy { pt =>
      (-pt.gates.length, pt.gates.headOption)
    }

    val newFinishersCount = gates.values.count(_.length == raceState.course.gatesToCross)

    raceState.copy(
      gates = gates,
      leaderboard = leaderboard,
      finishersCount = newFinishersCount
    )
  }

}
