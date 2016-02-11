package actors

import java.util.UUID
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
// import reactivemongo.bson.BSONObjectID

import models._
import dao._


case class GetTrackActorRef(track: Track)
case object GetTracks
case class ReloadTrack(track: Track)

case class RaceActorNotFound(raceId: UUID)

class RacesSupervisor extends Actor {
  var mountedTracks = Map.empty[UUID, (Track, ActorRef)]

  implicit val timeout = Timeout(5.seconds)

  def receive = {

    case GetTrackActorRef(track) => sender ! getTrackActorRef(track)

    case GetTracks => {
      Tracks.list().flatMap { tracks =>
        Future.sequence(tracks.map(getLiveTrack))
      }.pipeTo(sender)
    }

    case ReloadTrack(track) => {
      mountedTracks.get(track.id).map { case (_, ref) =>
        mountedTracks = mountedTracks + (track.id -> (track, ref))
        ref ! ReloadTrack(track)
      }
    }
  }

  def getLiveTrack(track: Track): Future[LiveTrack] = {
    mountedTracks.get(track.id) match {
      case Some((track, ref)) => {
        for {
          (races, opponents) <- (ref ? GetStatus).mapTo[(Seq[Race], Seq[Opponent])]
          meta <- trackMeta(track)
        }
        yield LiveTrack(track, meta, races, opponents.map(_.player))
      }
      case None => {
        trackMeta(track).map { meta => LiveTrack(track, meta, Nil, Nil) }
      }
    }
  }

  def getTrackActorRef(track: Track): ActorRef = {
    mountedTracks.get(track.id).map(_._2).getOrElse {
      val ref = context.actorOf(TrackActor.props(track))
      mountedTracks = mountedTracks + (track.id -> (track, ref))
      ref
    }
  }
}

object RacesSupervisor {

  val actorRef = Akka.system.actorOf(Props[RacesSupervisor])

  implicit val timeout = Timeout(5.seconds)

  def start() = {}

}
