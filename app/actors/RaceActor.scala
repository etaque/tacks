package actors


import scala.concurrent.duration._
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import play.api.Logger
import akka.actor._
import org.joda.time.DateTime
import models._

case class Start(at: DateTime)
case class PlayerQuit(id: String)
case object UpdateGameState
case object UpdateWind
case object SpawnBuoy
case object GetStartTime

class RaceActor(race: Race) extends Actor {

  type PlayerId = String
  case class SpellCast(by: PlayerId, spell: Spell, at: DateTime, to: Seq[PlayerId]) {
    def isExpired = at.plusSeconds(spell.duration).isBeforeNow
  }

  val playersStates = scala.collection.mutable.Map[PlayerId, PlayerState]()
  var wind = Wind.default.copy(gusts = Gust.spawnAll(race.course))
  var buoys = Seq[Buoy]()
  var spellCasts = Seq[SpellCast]()
  var leaderboard = Seq[String]()

  var previousWindUpdate = DateTime.now
  var startTime: Option[DateTime] = None

  def millisBeforeStart: Option[Long] = startTime.map(_.getMillis - DateTime.now.getMillis)
  def started = millisBeforeStart.exists(_ <= 0)

  Akka.system.scheduler.schedule(1.second, 1.second, self, UpdateGameState)
  Akka.system.scheduler.schedule(0.seconds, 10.milliseconds, self, UpdateWind)

  def receive = {

    case PlayerUpdate(id, input) => {
      val previousStateMaybe = playersStates.get(id)

      val runStep =
        withCollectedBuoy(race.course.boatWidth) _ andThen
        withCastedSpell(id, input.spellCast) andThen
        withCrossedGates(previousStateMaybe)

      val newState = runStep(previousStateMaybe.fold(input.makeState)(input.updateState))

      playersStates += (id -> newState)
      if (previousStateMaybe.exists(_.crossedGates != newState.crossedGates)) updateLeaderboard()

      if (input.startCountdown) startCountdown(byPlayerId = id)

      sender ! raceUpdateFor(id)
    }

    case PlayerQuit(id) => {
      Logger.debug("Boat quit: " + id)
      playersStates -= id
    }

    case UpdateGameState => {
      updateLeaderboard()
      updateSpells()
    }

    case UpdateWind => {
      val now = DateTime.now()
      wind = Wind(
        origin = race.course.windGenerator.windOrigin(now),
        speed = race.course.windGenerator.windSpeed(now),
        gusts = moveGusts(now, wind.gusts)
      )
      previousWindUpdate = now
    }

    case SpawnBuoy => {
      if (buoys.size < 10) {
        buoys = buoys :+ Buoy.spawn(race.course)
      }
    }

    case GetStartTime => sender ! startTime
  }

  private def startCountdown(byPlayerId: String) = {
    if (startTime.isEmpty && byPlayerId == race.userId.stringify) {
      val at = DateTime.now.plusSeconds(race.countdownSeconds)
      Logger.info(s"Race ${race.id} will start at $at")
      startTime = Some(at)
      Akka.system.scheduler.schedule(race.countdownSeconds.seconds, 20.seconds, self, SpawnBuoy)
    }
  }

  private def updateLeaderboard() = {
    if (playersStates.values.exists(_.crossedGates.nonEmpty)) {
      leaderboard = playersStates.toSeq.sortBy {
        case (_, b) => (-b.crossedGates.length, b.crossedGates.headOption.map(_.getMillis))
      }.map(_._2.name)
    }
  }

  private def withCollectedBuoy(boatWidth: Double)(state: PlayerState): PlayerState = {
    val newSpell: Option[Spell] = state.collision(boatWidth, buoys).filter(_ => started).map { buoy =>
      buoys = buoys.filterNot(_ == buoy) // Remove the spell from the game board
      buoy.spell
    }
    newSpell.fold(state)(state.withSpell)
  }

  private def withCastedSpell(id: PlayerId, castSpell: Boolean)(state: PlayerState): PlayerState = {
    state.ownSpell.filter(_ => castSpell).fold(state) { spell =>
      Logger.debug(s"Player ${state.name} casting spell $spell")
      spellCasts = spellCasts :+ SpellCast(by = id, spell, at = DateTime.now, to = playersStates.keys.filterNot(_ == id).toSeq)
      state.copy(ownSpell = None)
    }
  }

  private def withCrossedGates(previousStateMaybe: Option[PlayerState])(state: PlayerState): PlayerState = {
    previousStateMaybe.fold(state)(state.updateCrossedGates(race.course, started))
  }

  private def updateSpells() = {
    spellCasts = spellCasts.filterNot(_.isExpired)
  }

  private def moveGusts(at: DateTime, gusts: Seq[Gust]): Seq[Gust] = {
    gusts.map(_.update(race.course, wind, at, previousWindUpdate)).map { gust =>
      if (Geo.inBox(gust.position, race.course.bounds)) {
        gust
      } else {
        Gust.spawn(race.course)
      }
    }
  }

  private def raceUpdateFor(playerId: String) = {
    val ps = playersStates.get(playerId)
    RaceUpdate(
      now = DateTime.now,
      startTime = startTime,
      course = None, // already transmitted in initial update
      crossedGates = ps.map(_.crossedGates).getOrElse(Nil),
      nextGate = ps.flatMap(_.nextGate),
      wind = wind,
      opponents = playersStates.toSeq.filterNot(_._1 == playerId).map(_._2),
      leaderboard = leaderboard,
      buoys = buoys,
      playerSpell = ps.flatMap(_.ownSpell),
      triggeredSpells = spellCasts.filter(_.to.contains(playerId)).map(_.spell),
      isMaster = race.userId.stringify == playerId
    )
  }
}

object RaceActor {
  def props(race: Race) = Props(new RaceActor(race))
}
