package actors


import scala.concurrent.duration._
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import akka.actor._
import org.joda.time.DateTime
import models._

case class Start(at: DateTime)
case class PlayerQuit(id: String)
case object UpdateWind
case object GetStatus
case object AutoClean


class RaceActor(race: Race, master: Player) extends Actor {

  val fps = 30
  lazy val frameMillis = 1000 / fps

  type PlayerId = String
  case class SpellCast(by: PlayerId, spell: Spell, at: DateTime, to: Seq[PlayerId]) {
    def isExpired = at.plusSeconds(spell.duration).isBeforeNow
  }

  val playersStates = scala.collection.mutable.Map[PlayerId, PlayerState]()
  var wind = Wind.default.copy(gusts = Gust.spawnAll(race.course))
  var playersGates = scala.collection.mutable.Map[Player, Seq[DateTime]]()
  var leaderboard = Seq[PlayerTally]()
  var finishersCount = 0

  var previousWindUpdate = DateTime.now
  var startTime: Option[DateTime] = None

  def millisBeforeStart: Option[Long] = startTime.map(_.getMillis - DateTime.now.getMillis)
  def started = millisBeforeStart.exists(_ <= 0)

  lazy val gatesToCross = race.course.laps * 2 + 1
  def finished = playersGates.nonEmpty && playersGates.values.forall(_.length == gatesToCross)

  Akka.system.scheduler.schedule(10.seconds, 10.seconds, self, AutoClean)

  def receive = {

    case PlayerUpdate(player, input) => {
      val id = player.id.stringify
      val previousState = playersStates.getOrElse(id, PlayerState.initial(player))

      val now = DateTime.now

      if (previousWindUpdate.plusMillis(frameMillis).isBeforeNow) updateWind(now)
      if (input.startCountdown) startCountdown(byPlayerId = id)

      sender ! RunStep(previousState, input, now, wind, race, started, opponentsTo(id))
    }

    case StepResult(prevState, newState) => {
      val id = newState.player.id.stringify
      playersStates += (id -> newState)
      if (prevState.crossedGates != newState.crossedGates) updateTally()

      sender ! raceUpdateFor(id, newState)
    }

    case PlayerQuit(id) => {
      playersStates -= id
    }

    case GetStatus => sender ! (startTime, playersStates.toSeq)

    case AutoClean => {
      val deserted = race.creationTime.plusMinutes(1).isBeforeNow && playersStates.isEmpty
      val finished = startTime.exists(_.plusMinutes(20).isBeforeNow)
      if (deserted || finished) {
        self ! PoisonPill
      }
    }
  }

  private def updateWind(now: DateTime): Unit = {
    wind = Wind(
      origin = race.course.windGenerator.windOrigin(now),
      speed = race.course.windGenerator.windSpeed(now),
      gusts = moveGusts(now, wind.gusts)
    )
    previousWindUpdate = now
  }

  private def startCountdown(byPlayerId: String) = {
    if (startTime.isEmpty && byPlayerId == master.id.stringify) {
      val at = DateTime.now.plusSeconds(race.countdownSeconds)
      startTime = Some(at)
//      Race.updateStartTime(race, at)
    }
  }

  private def updateTally() = {
    playersStates.values.foreach { state =>
      playersGates += state.player -> state.crossedGates
    }

    leaderboard = playersGates.toSeq.map(t => PlayerTally(t._1.id, t._2)).sortBy { pt =>
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

  private def moveGusts(at: DateTime, gusts: Seq[Gust]): Seq[Gust] = {
    gusts.map(_.update(race.course, wind, previousWindUpdate, at)).map { gust =>
      if (Geo.inBox(gust.position, race.course.area.toBox)) {
        gust
      } else {
        Gust.spawn(race.course)
      }
    }
  }

  private def opponentsTo(playerId: String): Seq[PlayerState] = {
    playersStates.toSeq.filterNot(_._1 == playerId).map(_._2)
  }

  private def raceUpdateFor(playerId: String, playerState: PlayerState) = {
    RaceUpdate(
      now = DateTime.now,
      startTime = startTime,
      course = None, // already transmitted in initial update
      playerState = Some(playerState),
      wind = wind,
      opponents = opponentsTo(playerId),
      leaderboard = leaderboard,
      isMaster = master.id.stringify == playerId
    )
  }
}

object RaceActor {
  def props(race: Race, master: Player) = Props(new RaceActor(race, master))
}
