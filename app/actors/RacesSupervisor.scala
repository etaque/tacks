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
import models._
import dao._


object SupervisorAction {
  sealed trait Action

  case class GetTrackActorRef(track: Track) extends Action
  case class GetTimeTrialActorRef(timeTrial: TimeTrial, track: Track) extends Action
  case object GetTracks extends Action
  case class ReloadTrack(track: Track) extends Action
}

case class SupervisorState(
  mountedTracks: Map[UUID, (Track, ActorRef)]
) {
  def getTrackRef(trackId: UUID): Option[ActorRef] =
    mountedTracks.get(trackId).map(_._2)

  def mountTrack(track: Track, ref: ActorRef): SupervisorState =
    copy(mountedTracks = mountedTracks + (track.id -> (track, ref)))
}

class RacesSupervisor extends Actor {
  var state = SupervisorState(Map.empty)

  implicit val timeout = Timeout(5.seconds)

  import SupervisorAction._

  def receive = {

    case GetTrackActorRef(track) =>
      val ref = state.getTrackRef(track.id).getOrElse {
        val ref = context.actorOf(TrackActor.props(track))
        state = state.mountTrack(track, ref)
        ref
      }
      sender ! ref

    case GetTimeTrialActorRef(timeTrial, track) =>
      val ref = context.actorOf(TrackActor.props(track, Some(timeTrial)))
      sender ! ref

    case GetTracks =>
      Tracks.list().flatMap { tracks =>
        Future.sequence(tracks.map(getLiveTrack))
      }.pipeTo(sender)

    case ReloadTrack(track) => {
      state.mountedTracks.get(track.id).map { case (_, ref) =>
        state = state.mountTrack(track, ref)
        ref ! TrackAction.ReloadTrack(track)
      }
    }
  }

  private def getLiveTrack(track: Track): Future[LiveTrack] = {
    state.mountedTracks.get(track.id) match {
      case Some((track, ref)) => {
        for {
          (races, opponents) <- (ref ? TrackAction.GetStatus).mapTo[(Seq[Race], Seq[Opponent])]
          meta <- trackMeta(track)
        }
        yield LiveTrack(track, meta, races, opponents.map(_.player))
      }
      case None => {
        trackMeta(track).map { meta => LiveTrack(track, meta, Nil, Nil) }
      }
    }
  }
}

object RacesSupervisor {
  val actorRef = Akka.system.actorOf(Props[RacesSupervisor])

  implicit val timeout = Timeout(5.seconds)

  def start() = {}
}
