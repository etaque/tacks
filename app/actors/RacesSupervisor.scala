package actors

import tools.Conf

import scala.concurrent.Future
import scala.concurrent.duration._
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import play.api.Play.current
import akka.actor._
import akka.pattern.{ask,pipe}
import akka.util.Timeout
import org.joda.time.DateTime
import reactivemongo.bson.BSONObjectID
import models._
import core.Classic


case class MountRace(race: Race, master: Player)
case class UnmountRace(race: Race)
case class MountTimeTrialRun(timeTrial: TimeTrial, player: Player, run: TimeTrialRun)
case class MountTutorial(player: Player)
case class GetRace(raceId: BSONObjectID)
case class GetRaceActorRef(raceId: BSONObjectID)
case class GetRaceCourseActorRef(raceCourse: RaceCourse)
case object CreateRace
case object GetOpenRaces
case object GetLiveRuns
case object GetRaceCourses

case class RaceActorNotFound(raceId: BSONObjectID)

class RacesSupervisor extends Actor {
  var mountedRaces = Seq.empty[(Race, Option[Player], ActorRef)]
  var mountedRaceCourses = Seq.empty[(RaceCourse, ActorRef)]
  var mountedRuns = Seq.empty[(RichRun, ActorRef)]

  implicit val timeout = Timeout(5.seconds)

  def receive = {

    case CreateRace => {
      val race = new Race(
        course = Classic.generateCourse(),
        generator = Classic.slug,
        countdownSeconds = Conf.serverRacesCountdownSeconds
      )
      val ref = context.actorOf(RaceActor.props(race, None))
      mountedRaces = mountedRaces :+ (race, None, ref)
      context.watch(ref)
    }

    case MountRace(race, master) => {
      if (!mountedRaces.exists(_._1.id == race.id)) {
        val ref = context.actorOf(RaceActor.props(race, Some(master)))
        mountedRaces = mountedRaces :+ (race, Some(master), ref)
        context.watch(ref)
        Race.updateMounted(race.id, true)
        sender ! Unit
        master match {
          case u: User => Akka.system.scheduler.scheduleOnce(10.seconds, LiveCenter.actorRef, NotifyNewRace(ref, race, u))
          case g: Guest =>
        }
      }
    }

    case GetOpenRaces => {
      val racesFuture = mountedRaces.toSeq.map { case (race, master, ref) =>
        (ref ? GetStatus).mapTo[(Option[DateTime], Seq[Opponent])].map { case (startTime, opponents) =>
          RaceStatus(race, master, startTime, opponents)
        }
      }
      Future.sequence(racesFuture) pipeTo sender
    }

    case GetRace(raceId) => sender ! getRace(raceId)

    case GetRaceActorRef(raceId) => sender ! getRaceActorRef(raceId)

    case GetRaceCourseActorRef(raceCourse) => sender ! getRaceCourseActorRef(raceCourse)

    case GetLiveRuns => {
      sender ! mountedRuns.map(_._1)
    }

    case GetRaceCourses => {
      val raceCoursesFuture = mountedRaceCourses.toSeq.map { case (raceCourse, ref) =>
        (ref ? GetStatus).mapTo[(Option[RaceCourseRun], Seq[Opponent])].map { case (nextRun, opponents) =>
          RaceCourseStatus(raceCourse, nextRun, opponents)
        }
      }
      Future.sequence(raceCoursesFuture) pipeTo sender
    }

    case UnmountRace(race) => {
      Race.updateMounted(race.id, false)
      mountedRaces.find(_._1.id == race.id) match {
        case Some((_, _, ref)) => {
          if (sender != ref) ref ! PoisonPill
        }
        case None =>
      }
      sender ! Unit
    }

    case Terminated(ref) => {
      mountedRaces = mountedRaces.filterNot(_._3 == ref)
      mountedRuns = mountedRuns.filterNot(_._2 == ref)
    }

    case MountTimeTrialRun(timeTrial, player, run) => {
      val ref = context.actorOf(TimeTrialActor.props(timeTrial, player, run))
      mountedRuns = mountedRuns :+ (RichRun(run, timeTrial, player), ref)
      context.watch(ref)
      sender ! ref
    }

    case MountTutorial(player) => {
      val ref = context.actorOf(TutorialActor.props(player))
      context.watch(ref)
      sender ! ref
    }

  }

  def getRace(raceId: BSONObjectID): Option[Race] = mountedRaces.find(_._1.id == raceId).headOption.map(_._1)

  def getRaceActorRef(raceId: BSONObjectID): Option[ActorRef] = mountedRaces.find(_._1.id == raceId).map(_._3)

  def getRaceCourseActorRef(raceCourse: RaceCourse): ActorRef = {
    mountedRaceCourses.find(_._1.id == raceCourse.id).map(_._2).getOrElse {
      val ref = context.actorOf(RaceCourseActor.props(raceCourse))
      mountedRaceCourses = mountedRaceCourses :+ (raceCourse, ref)
      ref
    }
  }
}

object RacesSupervisor {

  val actorRef = Akka.system.actorOf(Props[RacesSupervisor])

  implicit val timeout = Timeout(5.seconds)

  def start() = {
    // Akka.system.scheduler.schedule(0.microsecond, Conf.serverRacesCountdownSeconds.seconds, actorRef, CreateRace)
  }


}
