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
case object UpdateLeaderboard
case object UpdateGusts

class RaceActor(race: Race) extends Actor {

  val playersStates = scala.collection.mutable.Map[String,BoatState]()
  val gusts = Seq[Gust]()
  var buoys: Seq[Buoy] = Buoy.default
  var leaderboard = Seq[String]()

  Akka.system.scheduler.schedule(1.minute, 1.second, self, UpdateLeaderboard)
  Akka.system.scheduler.schedule(1.minute, 1.second, self, UpdateGusts)

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
      playersStates += (id -> state.copy(ownSpell = newSpell.orElse(state.ownSpell)))
      sender ! raceUpdateFor(id)
    }
    case PlayerLeaved(id) => {
      Logger.debug("Boat leaved: " + id)
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
      playerSpells = bs.flatMap(_.ownSpell),
      triggeredSpells = bs.map(_.triggeredSpells).getOrElse(Nil)
    )
  }
}

object RaceActor {
  def props(race: Race) = Props(new RaceActor(race))
}




