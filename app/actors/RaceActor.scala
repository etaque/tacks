package actors


import scala.concurrent.duration._
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import play.api.Logger
import akka.actor._
import org.joda.time.DateTime
import models._

case class PlayerQuit(id: String)
case object UpdateGameState
case object UpdateWind
case object SpawnBuoy

class RaceActor(race: Race) extends Actor {

  type PlayerId = String
  case class SpellCast(by: PlayerId, spell: Spell, at: DateTime, to: Seq[PlayerId]) {
    def isExpired = at.plusSeconds(spell.duration).isBeforeNow
  }

  val playersStates = scala.collection.mutable.Map[PlayerId, PlayerState]()
  var wind = Wind.default.copy(gusts = Gust.default(race.course))
  var buoys = Seq[Buoy]()
  var spellCasts = Seq[SpellCast]()
  var leaderboard = Seq[String]()

  Akka.system.scheduler.schedule(1.second, 1.second, self, UpdateGameState)
  Akka.system.scheduler.schedule(0.seconds, 10.milliseconds, self, UpdateWind)
  Akka.system.scheduler.schedule(race.millisBeforeStart.millis, 20.seconds, self, SpawnBuoy)

  def receive = {

    case PlayerUpdate(id, input) => {
      val previousStateMaybe = playersStates.get(id)

      val runStep =
        withCollectedBuoy _ andThen
        withCastedSpell(id, input.spellCast) andThen
        withCrossedGates(previousStateMaybe)

      val newState = runStep(previousStateMaybe.fold(input.makeState)(input.updateState))

      playersStates += (id -> newState)
      if (previousStateMaybe.exists(_.crossedGates != newState.crossedGates)) updateLeaderboard()

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
    }

    case SpawnBuoy => {
      if (buoys.size < 10) {
        buoys = buoys :+ Buoy.spawn(race.course)
      }

    }
  }

  private def updateLeaderboard() = {
    if (playersStates.values.exists(_.crossedGates.nonEmpty)) {
      leaderboard = playersStates.toSeq.sortBy {
        case (_, b) => (-b.crossedGates.length, b.crossedGates.headOption.map(_.getMillis))
      }.map(_._2.name)
    }
  }

  private def withCollectedBuoy(state: PlayerState): PlayerState = {
    val newSpell: Option[Spell] = state.collision(buoys).filter(_ => race.started).map { buoy =>
      buoys = buoys.filterNot(_ == buoy) // Remove the spell from the game board
      buoy.spell
    }
    newSpell.fold(state)(state.withSpell)
  }

  private def withCastedSpell(id: PlayerId, castSpell: Boolean)(state: PlayerState): PlayerState = {
    state.ownSpell.filter(_ => castSpell).fold(state) { spell =>
      // The player is casting a spell!
      Logger.debug(s"Player ${state.name} casting spell $spell")
      spellCasts = spellCasts :+ SpellCast(by = id, spell, at = DateTime.now, to = playersStates.keys.filterNot(_ == id).toSeq)
      state.copy(ownSpell = None)
    }
  }

  private def withCrossedGates(previousStateMaybe: Option[PlayerState])(state: PlayerState): PlayerState = {
    previousStateMaybe.fold(state)(state.updateCrossedGates(race.course))
  }

  private def updateSpells() = {
    spellCasts = spellCasts.filterNot(_.isExpired)
  }

  private def moveGusts(at: DateTime, gusts: Seq[Gust]): Seq[Gust] = {
    val ms = at.getMillis
    gusts.map { gust =>
      val (cx,cy) = race.course.center
      val x = -(ms * gust.pixelSpeed * Math.cos(gust.radians)) % race.course.width + race.course.width / 2 + cx
      val y = -(ms * gust.pixelSpeed * Math.sin(gust.radians)) % race.course.height + race.course.height / 2 + cy
      val p = (x.toFloat,y.toFloat)

      if (Geo.inBox(p, race.course.bounds)) {
        gust.copy(position = p)
      } else {
        Gust.spawn(race.course, initial = false)
      }
    }
  }

  private def raceUpdateFor(boatId: String) = {
    val bs = playersStates.get(boatId)
    RaceUpdate(
      now = DateTime.now,
      startTime = race.startTime,
      course = None, // already transmitted in initial update
      crossedGates = bs.map(_.crossedGates).getOrElse(Nil),
      nextGate = bs.flatMap(_.nextGate),
      wind = wind,
      opponents = playersStates.toSeq.filterNot(_._1 == boatId).map(_._2),
      leaderboard = leaderboard,
      buoys = buoys,
      playerSpell = bs.flatMap(_.ownSpell),
      triggeredSpells = spellCasts.filter(_.to.contains(boatId)).map(_.spell)
    )
  }
}

object RaceActor {
  def props(race: Race) = Props(new RaceActor(race))
}
