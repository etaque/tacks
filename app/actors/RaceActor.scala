package actors

import scala.concurrent.duration._
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import play.api.Logger
import akka.actor._
import org.joda.time.DateTime
import models._

case class PlayerLeaved(id: String)
case object UpdateGameState
case object UpdateGusts

class RaceActor(race: Race) extends Actor {

  type PlayerId = String

  val playersStates = scala.collection.mutable.Map[PlayerId, BoatState]()
  var gusts: Seq[Gust] = Gust.default
  var buoys: Seq[Buoy] = Buoy.default
  val triggeredSpells = scala.collection.mutable.Map[PlayerId, Seq[(Spell, DateTime)]]() // datetime is expiration
  var leaderboard = Seq[String]()

  Akka.system.scheduler.schedule(1.second, 1.second, self, UpdateGameState)
  Akka.system.scheduler.schedule(0.seconds, 33.milliseconds, self, UpdateGusts)

  def receive = {
    case PlayerUpdate(id, state) => {
      val newSpell: Option[Spell] = playersStates.get(id) match {
        case Some(bs) => {
          if (bs.passedGates != state.passedGates) updateLeaderboard()
          bs.collisions(buoys).map { buoy =>
            buoys = buoys.filter(_ == buoy) // Remove the spell from the game board
            buoy.spell
          }
        }
        case None => None
      }
      if (state.spellCast == Some(true)) state.ownSpell.map { spell =>
        // The player is casting a spell!
        val expiration = DateTime.now().plusSeconds(spell.duration)
        playersStates.keys.filterNot(_ == id).map { opponentId =>
          triggeredSpells += opponentId -> (triggeredSpells.getOrElse(opponentId, Nil) :+ (spell, expiration))
        }
      }
      playersStates += (id -> state.copy(ownSpell = newSpell.orElse(state.ownSpell)))
      sender ! raceUpdateFor(id)
    }
    case PlayerLeaved(id) => {
      Logger.debug("Boat leaved: " + id)
      playersStates -= id
    }
    case UpdateGameState => updateGameState()
    case UpdateGusts => updateGusts()
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
    updateGusts()
  }

  private def updateSpells() = {
    // Spell expiration
    triggeredSpells.keys.foreach { boatId =>
      triggeredSpells += boatId -> triggeredSpells(boatId).filter { case (_, expiration) =>
        expiration.isAfterNow
      }
    }
  }

  private def updateGusts() = {
    val now = DateTime.now().getMillis
    gusts = gusts.map { gust =>
      val x = (gust.position._1 * now * gust.pixelSpeed * Math.cos(gust.radians)) % race.course.width
      val y = (gust.position._2 * now * gust.pixelSpeed * Math.sin(gust.radians)) % race.course.height
      gust.copy(position = (gust.position._1, gust.position._2 * gust.speed))
    }
  }

  private def raceUpdateFor(boatId: String) = {
    val bs = playersStates.get(boatId)
    RaceUpdate(
      now = DateTime.now,
      startTime = race.startTime,
      course = None, // already transmitted in initial update
      gusts = gusts,
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




