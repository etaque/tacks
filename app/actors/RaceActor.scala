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

class RaceActor(race: Race) extends Actor {

  type PlayerId = String

  val playersStates = scala.collection.mutable.Map[PlayerId, BoatState]()
  val gusts = Seq[Gust]()
  var buoys: Seq[Buoy] = Buoy.default
  val triggeredSpells = scala.collection.mutable.Map[PlayerId, Seq[(Spell, DateTime)]]() // datetime is expiration
  var leaderboard = Seq[String]()

  Akka.system.scheduler.schedule(1.minute, 1.second, self, UpdateGameState)

  def receive = {
    case PlayerUpdate(id, input) => {
      val state1 = playersStates.get(id).fold(input.makeState)(input.updateState)
      if (state1.passedGates != input.passedGates) updateLeaderboard()
      val newSpell: Option[Spell] = state1.collisions(buoys).map { buoy =>
        buoys = buoys.filterNot(_ == buoy) // Remove the spell from the game board
        buoy.spell
      }
      val state2 = newSpell.fold(state1)(state1.withSpell)
      val state3 = state2.ownSpell.filter(_ => input.spellCast).fold(state2) { spell =>
        // The player is casting a spell!
        val expiration = DateTime.now().plusSeconds(spell.duration)
        playersStates.keys.filterNot(_ == id).map { opponentId =>
          triggeredSpells += opponentId -> (triggeredSpells.getOrElse(opponentId, Nil) :+ (spell, expiration))
        }
        state2.copy(ownSpell = None)
      }
      playersStates += (id -> state3)
      sender ! raceUpdateFor(id)
    }
    case PlayerQuit(id) => {
      Logger.debug("Boat quit: " + id)
      playersStates -= id
    }
    case UpdateGameState => updateGameState()
  }

  private def updateLeaderboard() =
     if (playersStates.values.exists(_.passedGates.nonEmpty)) {
      leaderboard = playersStates.toSeq.sortBy {
        case (_, b) => (-b.passedGates.length, b.passedGates.headOption)
      }.map(_._1)
    }

  private def updateGameState() = {
    updateLeaderboard()
    updateSpells()
  }

  private def updateSpells() = {
    // Spell expiration
    triggeredSpells.keys.foreach { boatId =>
      triggeredSpells += boatId -> triggeredSpells(boatId).filter { case (_, expiration) =>
        expiration.isAfterNow
      }
    }
  }

  private def raceUpdateFor(boatId: String) = {
    val bs = playersStates.get(boatId)
    RaceUpdate(
      now = DateTime.now,
      startTime = race.startTime,
      course = None, // already transmitted in initial update
      gusts = Seq(),
      opponents = playersStates.toSeq.filterNot(_._1 == boatId).map(_._2),
      leaderboard = leaderboard,
      buoys = buoys,
      playerSpell = bs.flatMap(_.ownSpell),
      triggeredSpells = triggeredSpells.getOrElse(boatId, Nil).map(_._1)
    )
  }
}

object RaceActor {
  def props(race: Race) = Props(new RaceActor(race))
}
