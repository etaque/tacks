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

case class WatcherContext(watcher: Player, state: WatcherState, ref: ActorRef)
case class WatcherJoin(watcher: Player)
case class WatcherQuit(watcher: Player)

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
  val watchers = scala.collection.mutable.Map[PlayerId, WatcherContext]()

  def clock: Long = DateTime.now.getMillis

  val ticks = Seq(
    Akka.system.scheduler.schedule(10.seconds, 10.seconds, self, AutoClean),
    Akka.system.scheduler.schedule(0.seconds, 20.seconds, self, SpawnGust),
    Akka.system.scheduler.schedule(0.seconds, Conf.frameMillis.milliseconds, self, FrameTick)
  )

  def receive = {

    /**
     * player join => added to context Map
     */
    case PlayerJoin(player) => {
      players += player.id.stringify -> PlayerContext(player, PlayerInput.initial, PlayerState.initial(player), sender())
    }

    /**
     * player quit => removed from context Map
     */
    case PlayerQuit(player) => {
      players -= player.id.stringify
    }

    /**
     * game heartbeat:
     *  - update wind (origin, speed and gusts positions)
     *  - send a race update to watchers actors for websocket transmission
     *  - send a race update to players actor for websocket transmission
     *  - tell player actor to run step
     */
    case FrameTick => {

      updateWind()

      watchers.values.foreach {
        case WatcherContext(watcher, state, ref) => {
          ref ! raceUpdateForWatcher(watcher)
        }
      }

      players.values.foreach {
        case PlayerContext(player, input, state, ref) => {
          ref ! raceUpdateForPlayer(player, Some(state))
          ref ! RunStep(state, input, clock, wind, course, raceState.started, opponentsTo(player.id.stringify))
        }
      }
    }

    /**
     * player input coming from websocket through player actor
     * context is updated, race started if requested
     */
    case PlayerUpdate(player, input) => {
      val id = player.id.stringify

      players.get(id).foreach { context =>
        if (input.startCountdown) {
          raceState = RaceActor.startCountdown(raceState, byPlayerId = player.id)
        }
        players += (id -> context.copy(input = input))
      }
    }

    /**
     * step result coming from player actor
     * context is updated
     */
    case StepResult(prevState, newState) => {
      val id = newState.player.id.stringify

      players.get(id).foreach { context =>
        players += (id -> context.copy(state = newState))
        if (prevState.crossedGates != newState.crossedGates) {
          raceState = RaceActor.updateTally(raceState, players.values.map(_.state).toSeq)
          Race.updateFromState(raceState)
        }
      }
    }

    /**
     * watcher joins => added to context Map
     */
    case WatcherJoin(watcher) => {
      watchers += watcher.id.stringify -> WatcherContext(watcher, WatcherState(watcher.id.stringify), sender())
    }

    /**
     * watcher quits => removed from context Map
     */
    case WatcherQuit(watcher) => {
      watchers -= watcher.id.stringify
    }

    /**
     * watcher updates watcher player id => context updated
     */
    case WatcherUpdate(watcher, input) => {
      val id = watcher.id.stringify
      watchers.get(id).foreach { context =>
        val newState = WatcherState(input.watchedPlayerId.getOrElse(id))
        watchers += id -> context.copy(state = newState)
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

  def opponentsTo(playerId: String): Seq[PlayerState] = {
    players.toSeq.filterNot(_._1 == playerId).map(_._2.state)
  }

  def raceUpdateForPlayer(player: Player, playerState: Option[PlayerState]) = {
    val id = player.id.stringify
    RaceUpdate(
      playerId = id,
      now = DateTime.now,
      startTime = raceState.startTime,
      course = None, // already transmitted in initial update
      playerState = playerState,
      wind = wind,
      opponents = opponentsTo(id),
      leaderboard = raceState.leaderboard,
      isMaster = master.exists(_.id == player.id),
      watching = false,
      timeTrial = false
    )
  }

  def raceUpdateForWatcher(watcher: Player) = {
    RaceUpdate(
      playerId = watcher.id.stringify,
      now = DateTime.now,
      startTime = raceState.startTime,
      course = None, // already transmitted in initial update
      playerState = None,
      wind = wind,
      opponents = players.values.map(_.state).toSeq,
      leaderboard = raceState.leaderboard,
      isMaster = false,
      watching = true,
      timeTrial = false
    )
  }

  /**
   * kill remaining players and watchers actors
   */
  override def postStop() = {
    ticks.foreach(_.cancel())
    players.values.foreach(_.ref ! PoisonPill)
    watchers.values.foreach(_.ref ! PoisonPill)
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

  def updateTally(raceState: RaceState, playerStates: Seq[PlayerState]): RaceState = {

    val gates = playerStates.foldLeft(raceState.gates) { (gates, ps) =>
      gates + (ps.player -> ps.crossedGates)
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
