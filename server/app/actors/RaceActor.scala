package actors

import play.api.Logger
import akka.actor._
import models._

case class BoatLeaved(id: String)

class RaceActor(race: Race) extends Actor {

  val boatStates = scala.collection.mutable.Map[String,BoatState]()

  def receive = {
    case BoatUpdate(id, state) => {
      boatStates += (id -> state)
      sender ! raceUpdateFor(id)
    }
    case BoatLeaved(id) => {
      Logger.debug("Boat leaved: " + id)
      boatStates -= id
    }
  }

  private def raceUpdateFor(boatId: String) =
    RaceUpdate(race.startTime, boatStates.toSeq.filterNot(_._1 == boatId).map(_._2))
}

object RaceActor {
  def props(race: Race) = Props(new RaceActor(race))
}




