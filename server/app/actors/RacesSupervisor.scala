package actors

import akka.actor.{Terminated, ActorRef, Actor}
import models.Race
import play.api.Logger

case class GetRaceActor(race: Race)

class RacesSupervisor extends Actor {
  var raceActors = Map.empty[String, ActorRef]

  def getRaceActor(race: Race) = raceActors.getOrElse(race.id, {
    Logger.debug("Creating actor for race " + race.id)
    val a = context actorOf RaceActor.props(race)
    raceActors += race.id -> a
    context watch a
    a
  })

  def receive = {
    case Terminated(ref) => raceActors = raceActors filterNot { case (_, v) => v == ref }
    case GetRaceActor(race) => sender ! getRaceActor(race)
  }
}