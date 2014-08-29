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
case object UpdateLeaderboard
case object UpdateGusts

class RaceActor(race: Race) extends Actor {

  val playersStates = scala.collection.mutable.Map[String,BoatState]()
  val gusts = Seq[Gust]()
  var buoys: Seq[Buoy] = Buoy.default
  var leaderboard = Seq[String]()

  Akka.system.scheduler.schedule(1.minute, 1.second, self, UpdateLeaderboard)
  Akka.system.scheduler.schedule(1.minute, 1.second, self, UpdateGusts)

  case object UpdateSpells
  Akka.system.scheduler.schedule(1.second, 1.second, self, UpdateSpells)

  def receive = {
    case UpdateSpells => {
      playersStates foreach {
        case (id, state) => playersStates += (id -> state.copy(
          ownSpell = state.ownSpell.fold[Option[Spell]](Some(Spell(kind = "PoleInversion", duration = 5)))(_ => None)
        ))
      }
      println(playersStates)
    }
    case PlayerUpdate(id, input) => {
      playersStates.get(id) match {
        case Some(state) => {
          if (state.passedGates != input.passedGates) updateLeaderboard()
          state.collisions(buoys).map { buoy =>
            buoys = buoys.filter(_ == buoy) // Remove the spell from the game board
            playersStates += (id -> state.copy(ownSpell = Some(buoy.spell)))
          }
          sender ! raceUpdateFor(id)
        }
        case None =>
      }
    }
    case PlayerQuit(id) => {
      Logger.debug("Boat quit: " + id)
      playersStates -= id
    }
    case UpdateLeaderboard => updateLeaderboard()
  }

  private def updateLeaderboard() =
    if (playersStates.values.exists(_.passedGates.nonEmpty)) {
      leaderboard = playersStates.toSeq.sortBy {
        case (_, b) => (- b.passedGates.length, b.passedGates.headOption)
      }.map(_._1)
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
      triggeredSpells = bs.map(_.triggeredSpells).getOrElse(Nil)
    )
  }
}

object RaceActor {
  def props(race: Race) = Props(new RaceActor(race))
}
