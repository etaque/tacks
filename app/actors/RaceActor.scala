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

class RaceActor(race: Race) extends Actor {

  val boatStates = scala.collection.mutable.Map[String,BoatState]()
  var leaderboard = Seq[String]()

  Akka.system.scheduler.schedule(1.minute, 1.second, self, UpdateLeaderboard)

  def receive = {
    case PlayerUpdate(id, state) => {
      boatStates.get(id) match {
        case Some(bs) => if (bs.passedGates != state.passedGates) updateLeaderboard()
        case None =>
      }
      boatStates += (id -> state)
      sender ! raceUpdateFor(id)
    }
    case PlayerLeaved(id) => {
      Logger.debug("Boat leaved: " + id)
      boatStates -= id
    }
    case UpdateLeaderboard => updateLeaderboard()
  }

  private def updateLeaderboard() =
    if (boatStates.values.exists(_.passedGates.nonEmpty)) {
      leaderboard = boatStates.toSeq.sortBy {
        case (_, b) => (- b.passedGates.length, b.passedGates.headOption)
      }.map(_._1)
    }

  private def raceUpdateFor(boatId: String) =
    RaceUpdate(
      now = DateTime.now,
      startTime = race.startTime,
      course = None, // already transmitted in initial update
      opponents = boatStates.toSeq.filterNot(_._1 == boatId).map(_._2),
      leaderboard = leaderboard
    )
}

object RaceActor {
  def props(race: Race) = Props(new RaceActor(race))
}




