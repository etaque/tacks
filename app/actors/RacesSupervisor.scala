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
case class KillTrack(track: Track)

case class RaceActorNotFound(raceId: BSONObjectID)

class RacesSupervisor extends Actor {
  var mountedTracks = Seq.empty[(Track, ActorRef)]

  implicit val timeout = Timeout(5.seconds)

  def receive = {

    case GetTrackActorRef(track) => sender ! getTrackActorRef(track)

    case GetTracks => {
      TrackDAO.list.flatMap { tracks => Future.sequence(tracks.map(getLiveTrack)) } pipeTo sender
    }

    case KillTrack(track: Track) => {
      mountedTracks.find(_._1.slug == track.slug).foreach(_._2 ! PoisonPill)
      mountedTracks = mountedTracks.filter(_._1.slug != track.slug)
    }
  }

  def getLiveTrack(track: Track): Future[LiveTrack] = {
    mountedTracks.find(_._1.slug == track.slug) match {
      case Some((track, ref)) => {
        for {
          (races, opponents) <- (ref ? GetStatus).mapTo[(Seq[Race], Seq[Opponent])]
          rankings <- RacesSupervisor.playerRankings(track.id)
        }
        yield LiveTrack(track, races, opponents.map(_.player), rankings)
      }
      case None => {
        RacesSupervisor.playerRankings(track.id).map { rankings =>
          LiveTrack(track, Nil, Nil, rankings)
        }
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

  def playerRankings(trackId: BSONObjectID): Future[Seq[PlayerRanking]] = {
    for {
      runRankings <- RunDAO.extractRankings(trackId)
      players <- UserDAO.listByIds(runRankings.map(_.playerId))
      playerRankings = runRankings.flatMap(r => players.find(_.id == r.playerId).map(p => PlayerRanking(r.rank, p, r.finishTime)))
    }
    yield playerRankings
  }


}
