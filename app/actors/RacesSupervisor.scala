package actors

import scala.concurrent.duration._
import scala.collection.mutable.ListBuffer
import play.api.Logger
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import play.api.Play.current
import akka.actor.{Props, Terminated, ActorRef, Actor}
import org.joda.time.DateTime
import reactivemongo.bson.BSONObjectID
import models.{Course, Race}


case class GetRace(raceId: BSONObjectID)
case class GetRaceActor(raceId: BSONObjectID)
case object GetNextRace
case object CreateRace

class RacesSupervisor extends Actor {
  var raceActors = Map.empty[BSONObjectID, ActorRef]

  var races = ListBuffer[Race]()

  def receive = {
    case CreateRace => createRace
    case GetNextRace => sender ! getNextRace
    case GetRace(raceId) => sender ! getRace(raceId)
    case GetRaceActor(raceId) => sender ! getRaceActor(raceId)
    case Terminated(ref) => raceActors = raceActors.filterNot { case (_, v) => v == ref }
  }

  def getRace(raceId: BSONObjectID) = races.find(_.id == raceId).headOption

  def getRaceActor(raceId: BSONObjectID) = raceActors.get(raceId)

  def getNextRace: Option[Race] =
    races.filter(_.startTime.minusSeconds(30).isAfterNow).sortBy(_.startTime.getMillis).headOption

  def createRace = {
    Logger.debug("New race")
    val race = Race(startTime = DateTime.now().plusMinutes(2), course = Course.default)
    Logger.debug("Creating actor for race " + race.id)
    val ref = context.actorOf(RaceActor.props(race))
    raceActors += race.id -> ref
    context.watch(ref)
    races = (race +: races).take(5)
    // TODO save races
  }

}

object RacesSupervisor {

  val actorRef = Akka.system.actorOf(Props[RacesSupervisor])

  def start() = {
    Akka.system.scheduler.schedule(0.microsecond, 1.minutes, actorRef, CreateRace)
  }

}
