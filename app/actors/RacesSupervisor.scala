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
import dao._


case class GetTrackActorRef(track: Track)
case object GetTracks

case class RaceActorNotFound(raceId: BSONObjectID)

class RacesSupervisor extends Actor {
  var mountedTracks = Seq.empty[(Track, ActorRef)]

  implicit val timeout = Timeout(5.seconds)

  def receive = {

    case GetTrackActorRef(track) => sender ! getTrackActorRef(track)

    case GetTracks => {
      TrackDAO.list.flatMap { tracks => Future.sequence(tracks.map(getLiveTrack)) } pipeTo sender
    }

  }

  def getLiveTrack(track: Track): Future[LiveTrack] = {
    mountedTracks.find(_._1.slug == track.slug) match {
      case Some((track, ref)) => {
        (ref ? GetStatus).mapTo[(Option[Race], Seq[Opponent])].map { case (nextRace, opponents) =>
          LiveTrack(track, nextRace, opponents.map(_.player))
        }
      }
      case None => {
        Future.successful(LiveTrack(track, None, Nil))
      }
    }
  }

  def getTrackActorRef(track: Track): ActorRef = {
    mountedTracks.find(_._1.id == track.id).map(_._2).getOrElse {
      val ref = context.actorOf(TrackActor.props(track))
      mountedTracks = mountedTracks :+ (track, ref)
      ref
    }
  }
}

object RacesSupervisor {

  val actorRef = Akka.system.actorOf(Props[RacesSupervisor])

  implicit val timeout = Timeout(5.seconds)

  def start() = {}


}
