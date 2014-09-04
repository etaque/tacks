package actors

import scala.concurrent.Future
import scala.concurrent.duration._
import scala.collection.mutable.ListBuffer
import play.api.Logger
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import play.api.Play.current
import akka.actor.{Props, Terminated, ActorRef, Actor}
import akka.pattern.{ask,pipe}
import akka.util.Timeout
import org.joda.time.DateTime
import reactivemongo.bson.BSONObjectID
import models.{Race,User}


case class MountRace(race: Race, master: User)
case class GetRace(raceId: BSONObjectID)
case class GetRaceActorRef(raceId: BSONObjectID)
case object GetPublicRaces

case class RaceActorNotFound(raceId: BSONObjectID)

class RacesSupervisor extends Actor {
  var mountedRaces = Seq[(Race, User, ActorRef)]()

  implicit val timeout = Timeout(5.seconds)

  def receive = {

    case MountRace(race, master) => {
      val ref = context.actorOf(RaceActor.props(race, master))
      mountedRaces = mountedRaces :+ (race, master, ref)
      context.watch(ref)
      sender ! Unit
    }

    case GetPublicRaces => {
      val racesFuture = mountedRaces.toSeq.filterNot(_._1.isPrivate).map { case (race, master, ref) =>
        (ref ? GetStartTime).mapTo[Option[DateTime]].map { t => (race, master, t) }
      }
      Future.sequence(racesFuture) pipeTo sender
    }

    case GetRace(raceId) => sender ! getRace(raceId)

    case GetRaceActorRef(raceId) => sender ! getRaceActorRef(raceId)

    case Terminated(ref) => mountedRaces = mountedRaces.filterNot { case (_, _, r) => r == ref }
  }

  def getRace(raceId: BSONObjectID): Option[Race] = mountedRaces.find(_._1.id == raceId).headOption.map(_._1)

  def getRaceActorRef(raceId: BSONObjectID): Option[ActorRef] = mountedRaces.find(_._1.id == raceId).map(_._3)
}

object RacesSupervisor {

  val actorRef = Akka.system.actorOf(Props[RacesSupervisor])

  def start() = {
//    Akka.system.scheduler.schedule(0.microsecond, 1.minutes, actorRef, CreateRace)
  }

}
