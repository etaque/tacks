package actors

import reactivemongo.bson.BSONObjectID
import tools.Conf

import scala.concurrent.duration._
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import akka.actor._
import org.joda.time.DateTime
import models._

case class Start(at: DateTime)
case class PlayerContext(player: Player, input: KeyboardInput, state: OpponentState, ref: ActorRef) {
  def asOpponent = Opponent(state, player)
}

class RaceActor(race: Race, master: Option[Player]) extends Actor with ManageWind {

  val id = race.id
  val course = race.course

  type PlayerId = String
  case class SpellCast(by: PlayerId, spell: Spell, at: DateTime, to: Seq[PlayerId]) {
    def isExpired = at.plusSeconds(spell.duration).isBeforeNow
  }

  val players = scala.collection.mutable.Map[PlayerId, PlayerContext]()
  val playersGates = scala.collection.mutable.Map[Player, Seq[Long]]()
  var leaderboard = Seq[PlayerTally]()
  var finishersCount = 0

  var startTime: Option[DateTime] = if (master.isEmpty) Some(DateTime.now.plusSeconds(race.countdownSeconds)) else None

  def millisBeforeStart: Option[Long] = startTime.map(_.getMillis - DateTime.now.getMillis)
  def startScheduled = startTime.isDefined
  def started = startTime.exists(_.isBeforeNow)
  def clock: Long = DateTime.now.getMillis

  def finished = playersGates.nonEmpty && playersGates.values.forall(_.length == course.gatesToCross)

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
        if (input.startCountdown) startCountdown(byPlayerId = player.id)
        players += (id -> context.copy(input = input, state = state))
        if (context.state.crossedGates != state.crossedGates) updateTally()
        context.ref ! raceUpdateForPlayer(player, clientTime)
      }
    }

    /**
     * race status, for live center
     */
    case GetStatus => sender ! (startTime, players.values.map(_.asOpponent).toSeq)

    /**
     * new gust
     */
    case SpawnGust => generateGust()

    /**
     * clean obsolete races
     * kill remaining players and watchers actors
     */
    case AutoClean => {
      val deserted = master match {
        case Some(_) => players.isEmpty && race.creationTime.plusMinutes(1).isBeforeNow
        case None => players.isEmpty && startTime.exists(_.isBeforeNow)
      }
      val finished = startTime.exists(_.plusMinutes(10).isBeforeNow)
      if (deserted || finished) {
        players.values.foreach(_.ref ! PoisonPill)
        self ! PoisonPill
      }
    }
  }

  private def startCountdown(byPlayerId: BSONObjectID) = {
    if (startTime.isEmpty && master.exists(_.id == byPlayerId)) {
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
      (-pt.gates.length, pt.gates.headOption)
    }

    val fc = playersGates.values.count(_.length == course.gatesToCross)

    if (fc != finishersCount) {
      fc match {
        case 1 => // ignore
        case 2 => Race.save(race.copy(tally = leaderboard, startTime = startTime))
        case _ => Race.updateTally(race, leaderboard)
      }
    }
    finishersCount = fc
  }

  private def opponentsTo(playerId: String): Seq[Opponent] = {
    players.toSeq.filterNot(_._1 == playerId).map(_._2.asOpponent)
  }

  private def raceUpdateForPlayer(player: Player, clientTime: Long) = {
    RaceUpdate(
      serverNow = DateTime.now,
      startTime = startTime,
      wind = wind,
      opponents = opponentsTo(player.id.stringify),
      leaderboard = leaderboard,
      isMaster = master.exists(_.id == player.id),
      clientTime = clientTime
    )
  }

  override def postStop() = ticks.foreach(_.cancel())
}

object RaceActor {
  def props(race: Race, master: Option[Player]) = Props(new RaceActor(race, master))
}
