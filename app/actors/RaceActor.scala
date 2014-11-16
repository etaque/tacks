package actors

import scala.concurrent.duration._
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import akka.actor._
import org.joda.time.DateTime
import models._

case class Start(at: DateTime)

case class PlayerContext(player: Player, input: PlayerInput, state: PlayerState, ref: ActorRef)
case class PlayerJoin(player: Player)
case class PlayerQuit(player: Player)

case class WatcherContext(watcher: Player, state: WatcherState, ref: ActorRef)
case class WatcherJoin(watcher: Player)
case class WatcherQuit(watcher: Player)

case object FrameTick
case object SpawnGust
case object GetStatus
case object AutoClean

class RaceActor(race: Race, master: Player) extends Actor {

  val fps = 30
  val frameMillis = 1000 / fps

  type PlayerId = String
  case class SpellCast(by: PlayerId, spell: Spell, at: DateTime, to: Seq[PlayerId]) {
    def isExpired = at.plusSeconds(spell.duration).isBeforeNow
  }

  val players = scala.collection.mutable.Map[PlayerId, PlayerContext]()
  var wind = Wind.default //.copy(gusts = Gust.spawnAll(race.course))
  var playersGates = scala.collection.mutable.Map[Player, Seq[DateTime]]()
  var leaderboard = Seq[PlayerTally]()
  var finishersCount = 0

  val watchers = scala.collection.mutable.Map[PlayerId, WatcherContext]()

  var previousWindUpdate = DateTime.now
  var startTime: Option[DateTime] = None

  def millisBeforeStart: Option[Long] = startTime.map(_.getMillis - DateTime.now.getMillis)
  def startScheduled = startTime.isDefined
  def started = startTime.exists(_.isBeforeNow)
  def clock: Long = millisBeforeStart.map(-_).getOrElse(-race.countdownSeconds * 1000L)

  val gatesToCross = race.course.laps * 2 + 1
  def finished = playersGates.nonEmpty && playersGates.values.forall(_.length == gatesToCross)

  val ticks = Seq(
    Akka.system.scheduler.schedule(10.seconds, 10.seconds, self, AutoClean),
    Akka.system.scheduler.schedule(0.seconds, 20.seconds, self, SpawnGust),
    Akka.system.scheduler.schedule(0.seconds, frameMillis.milliseconds, self, FrameTick)
  )

  def receive = {

    /**
     * player join => added to context Map
     */
    case PlayerJoin(player) => {
      players += player.id.stringify -> PlayerContext(player, PlayerInput.initial, PlayerState.initial(player), sender)
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
      val now = DateTime.now

      updateWind(now)

      watchers.values.foreach {
        case WatcherContext(watcher, state, ref) => {
          ref ! raceUpdateForWatcher(watcher)
        }
      }

      players.values.foreach {
        case PlayerContext(player, input, state, ref) => {
          ref ! raceUpdateForPlayer(player, Some(state))
          ref ! RunStep(state, input, now, wind, race, started, opponentsTo(player.id.stringify))
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
        if (input.startCountdown) startCountdown(byPlayerId = id)
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
        if (prevState.crossedGates != newState.crossedGates) updateTally()
      }
    }

    /**
     * watcher joins => added to context Map
     */
    case WatcherJoin(watcher) => {
      watchers += watcher.id.stringify -> WatcherContext(watcher, WatcherState(watcher.id.stringify), sender)
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
    case GetStatus => sender ! (startTime, players.values.map(_.state).toSeq)

    /**
     * new gust
     */
    case SpawnGust => {
      wind = wind.copy(gusts = wind.gusts :+ Gust.generate(race.course, clock))
    }

    /**
     * clean obsolete races
     * kill remaining players and watchers actors
     */
    case AutoClean => {
      val deserted = race.creationTime.plusMinutes(1).isBeforeNow && players.isEmpty
      val finished = startTime.exists(_.plusMinutes(20).isBeforeNow)
      if (deserted || finished) {
        players.values.foreach(_.ref ! PoisonPill)
        watchers.values.foreach(_.ref ! PoisonPill)
        self ! PoisonPill
      }
    }
  }

  private def updateWind(now: DateTime): Unit = {
    wind = Wind(
      origin = race.course.windGenerator.windOrigin(clock),
      speed = race.course.windGenerator.windSpeed(clock),
      gusts = if (startScheduled) moveGusts(clock, wind.gusts, now.getMillis - previousWindUpdate.getMillis) else wind.gusts
    )
    previousWindUpdate = now
  }

  private def startCountdown(byPlayerId: String) = {
    if (startTime.isEmpty && byPlayerId == master.id.stringify) {
      val at = DateTime.now.plusSeconds(race.countdownSeconds)
      startTime = Some(at)
    }
  }

  private def updateTally() = {
    players.values.foreach { context =>
      playersGates += context.player -> context.state.crossedGates
    }

    leaderboard = playersGates.toSeq.map { case (player, gates) =>
      PlayerTally(player.id, player match {
        case g: Guest => None
        case u: User => Some(u.handle)
      }, gates)
    }.sortBy { pt =>
      (-pt.gates.length, pt.gates.headOption.map(_.getMillis))
    }

    val fc = playersGates.values.count(_.length == gatesToCross)

    if (fc != finishersCount) {
      fc match {
        case 1 => // ignore
        case 2 => Race.save(race.copy(tally = leaderboard, startTime = startTime))
        case _ => Race.updateTally(race, leaderboard)
      }
    }
    finishersCount = fc
  }

  private def moveGusts(clock: Long, gusts: Seq[Gust], elapsed: Long): Seq[Gust] = {
    gusts
      .map(_.update(race.course, wind, elapsed, clock))
      .filter(g => g.position._2 - g.radius > race.course.area.bottom)
  }

  private def opponentsTo(playerId: String): Seq[PlayerState] = {
    players.toSeq.filterNot(_._1 == playerId).map(_._2.state)
  }

  private def raceUpdateForPlayer(player: Player, playerState: Option[PlayerState]) = {
    val id = player.id.stringify
    RaceUpdate(
      playerId = id,
      now = DateTime.now,
      startTime = startTime,
      course = None, // already transmitted in initial update
      playerState = playerState,
      wind = wind,
      opponents = opponentsTo(id),
      leaderboard = leaderboard,
      isMaster = id == master.id.stringify,
      watching = false
    )
  }

  private def raceUpdateForWatcher(watcher: Player) = {
    RaceUpdate(
      playerId = watcher.id.stringify,
      now = DateTime.now,
      startTime = startTime,
      course = None, // already transmitted in initial update
      playerState = None,
      wind = wind,
      opponents = players.values.map(_.state).toSeq,
      leaderboard = leaderboard,
      isMaster = false,
      watching = true
    )
  }


  override def postStop() = ticks.foreach(_.cancel())
}

object RaceActor {
  def props(race: Race, master: Player) = Props(new RaceActor(race, master))
}
