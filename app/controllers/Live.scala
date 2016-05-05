package controllers

import java.util.UUID
import play.api.Play
import play.api.db.slick.DatabaseConfigProvider
import play.api.libs.concurrent.Execution.Implicits._
import scala.concurrent.Future
import scala.concurrent.duration._
import play.api.mvc._
import play.api.libs.json._
import play.api.libs.functional.syntax._
import play.api.libs.json.Reads._
import play.api.Play.current
import akka.util.Timeout
import akka.pattern.{ ask, pipe }
import org.joda.time.DateTime
import play.api.i18n.Messages.Implicits._

import actors._
import models._
import models.JsonFormats._
import slick.driver.JdbcProfile
import tools.future.Implicits._
import tools.JsonErrors

import scala.util.Try

object Live extends Controller with Security {

  implicit val timeout = Timeout(5.seconds)

  def status = PlayerAction.async() { implicit request =>
    val tracksFu = (RacesSupervisor.actorRef ? SupervisorAction.GetTracks).mapTo[Seq[LiveTrack]]
    val draftsFu = dao.Tracks.listByCreatorId(request.player.id).map(_.filter(_.isDraft))
    val onlinePlayersFu = (LiveCenter.actorRef ? GetOnlinePlayers).mapTo[Seq[Player]]
    for {
      tracks <- tracksFu
      homeLiveTracks = tracks.filter(_.track.isOpen).sortBy(_.meta.rankings.length).reverse
      drafts <- draftsFu
      onlinePlayers <- onlinePlayersFu
    }
    yield Ok(Json.obj(
               "liveTracks" -> Json.toJson(homeLiveTracks),
               "drafts" -> Json.toJson(drafts),
               "onlinePlayers" -> Json.toJson(onlinePlayers)
             ))
  }

  def allTracks = PlayerAction.async() { implicit request =>
    val tracksFu = (RacesSupervisor.actorRef ? SupervisorAction.GetTracks).mapTo[Seq[LiveTrack]]
    for {
      tracks <- tracksFu
      openLiveTracks = tracks.filter(_.track.isOpen)
    }
    yield Ok(Json.toJson(openLiveTracks))
  }


  def track(id: UUID) = PlayerAction.async() { implicit request =>
    val allFu = (RacesSupervisor.actorRef ? SupervisorAction.GetTracks).mapTo[Seq[LiveTrack]]
    allFu.map { liveTracks =>
      liveTracks.find(_.track.id == id) match {
        case Some(rcs) =>
          Ok(Json.toJson(rcs))
        case None =>
          NotFound
      }
    }
  }

  def allRaceReports(minPlayers: Option[Int]) =
    raceReports(minPlayers, None)

  def trackRaceReports(id: UUID, minPlayers: Option[Int]) =
    raceReports(minPlayers, Some(id))

  private def raceReports(minPlayers : Option[Int], trackId: Option[UUID]) = PlayerAction.async() { implicit request =>
    for {
      raceIds <- dao.Runs.lastRaceIds(12, minPlayers, trackId)
      runs <- dao.Runs.listForRaces(raceIds)
      tracks <- dao.Tracks.list()
      reports = runs.groupBy(_.raceId).flatMap { case (raceId, runs) =>
        for {
          firstRun <- runs.headOption
          track <- tracks.find(_.id == firstRun.trackId)
        } yield RaceReport(raceId, firstRun.startTime, track.id, track.name, runs)
      }.toSeq.sortBy(_.startTime.getMillis * -1)
    } yield {
      Ok(Json.toJson(reports))
    }
  }
}
