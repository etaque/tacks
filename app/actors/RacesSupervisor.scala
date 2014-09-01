package actors

import akka.actor.Status.Failure
import akka.util.Timeout

import scala.concurrent.Future
import scala.concurrent.duration._
import scala.collection.mutable.ListBuffer
import play.api.Logger
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import play.api.Play.current
import akka.actor.{Props, Terminated, ActorRef, Actor}
import akka.pattern.{ask,pipe}
import org.joda.time.DateTime
import reactivemongo.bson.BSONObjectID
import models.Race


case class MountRace(race: Race)
case class GetRace(raceId: BSONObjectID)
case class GetRaceActorRef(raceId: BSONObjectID)
case object GetPublicRaces

case class RaceActorNotFound(raceId: BSONObjectID)

class RacesSupervisor extends Actor {
  var raceActors = Map.empty[BSONObjectID, ActorRef]
  var races = ListBuffer[Race]()

  implicit val timeout = Timeout(5.seconds)

  def receive = {

    case MountRace(race) => {
      Logger.debug(s"Mounting race ${race.id}")
      races += race
      val ref = context.actorOf(RaceActor.props(race))
      raceActors += race.id -> ref
      context.watch(ref)
      sender ! Unit
    }

    case GetPublicRaces => {
      val racesFuture = races.toSeq.filterNot(_.isPrivate).flatMap { race =>
        getRaceActorRef(race.id).map { ref =>
          (ref ? GetStartTime).mapTo[Option[DateTime]].map { t => (race, t) }
        }
      }
      Future.sequence(racesFuture) pipeTo sender
    }

    case GetRace(raceId) => sender ! getRace(raceId)

    case GetRaceActorRef(raceId) => sender ! getRaceActorRef(raceId)

    case Terminated(ref) => raceActors = raceActors.filterNot { case (_, v) => v == ref }
  }

  def getRace(raceId: BSONObjectID): Option[Race] = races.find(_.id == raceId).headOption

  def getRaceActorRef(raceId: BSONObjectID): Option[ActorRef] = raceActors.get(raceId)
}

object RacesSupervisor {

  val actorRef = Akka.system.actorOf(Props[RacesSupervisor])

  def start() = {
//    Akka.system.scheduler.schedule(0.microsecond, 1.minutes, actorRef, CreateRace)
  }

}
