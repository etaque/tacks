package controllers


import play.api.i18n.Messages

import scala.concurrent.Future
import scala.concurrent.duration._
import play.api.data._
import play.api.data.Forms._
import play.api.libs.concurrent.Execution.Implicits._
import play.api.mvc.Controller
import akka.pattern.{ ask, pipe }
import akka.util.Timeout
import org.joda.time.DateTime
import reactivemongo.bson.BSONObjectID

import models.{User, TournamentState, Tournament, Race}
import actors.{UnmountRace, MountRace, RacesSupervisor}
import core.{Classic, CourseGenerator}

case class TournamentData(name: String, meetTime: Option[DateTime], description: Option[String])
case class TournamentRaceData(generator: String, startTime: Option[DateTime])

object Tournaments extends Controller with Security {

  implicit val timeout = Timeout(5.seconds)

  def index = PlayerAction.async() { implicit request =>
    for {
      races <- Race.listFinished(10)
      openTournaments <- Tournament.listOpen.flatMap(Tournament.enrich)
      finishedTournaments <- Tournament.listFinished.flatMap(Tournament.enrich)
    }
    yield {
      Ok(views.html.tournaments.index(openTournaments, finishedTournaments))
    }
  }

  val tournamentForm = Form(
    mapping(
      "name" -> nonEmptyText,
      "meetTime" -> optional(jodaDate("yyyy-MM-dd'T'HH:mm")),
      "description" -> optional(text)
    )(TournamentData.apply)(TournamentData.unapply)
  )

  def creation = PlayerAction.async() { implicit request =>
    asUser { _ =>
      Future.successful(Ok(views.html.tournaments.creation(tournamentForm)))
    }
  }

  def create = PlayerAction.async(parse.urlFormEncoded) { implicit request =>
    asUser { user =>
      tournamentForm.bindFromRequest().fold(
        withErrors => Future.successful(BadRequest(views.html.tournaments.creation(withErrors))),
        {
          case TournamentData(name, meetTime, description) => {
            val t = Tournament(BSONObjectID.generate, user.id, name, meetTime, description, TournamentState.open)
            Tournament.save(t).map { _ =>
              Redirect(routes.Tournaments.show(t.id.stringify))
            }
          }
        }
      )
    }
  }

  def show(id: String) = PlayerAction.async() { implicit request =>
    for {
      tournament <- Tournament.findById(id)
      races <- Race.listByTournamentId(tournament.id)
      users <- User.listByIds(races.flatMap(_.rankedPlayerIds).distinct)
    }
    yield {
      val pendingRaces = races.filterNot(_.finished).sortBy(_.startTime.map(_.getMillis))
      val finishedRaces = races.filter(_.finished).sortBy(_.startTime.map(_.getMillis))
      Ok(views.html.tournaments.show(tournament, pendingRaces, finishedRaces, users))
    }
  }

  def edit(id: String) = PlayerAction.async() { implicit request =>
    for {
      t <- Tournament.findById(id)
      if t.masterId == request.player.id
    }
    yield {
      val form = tournamentForm.fill(TournamentData(t.name, t.meetTime, t.description))
      Ok(views.html.tournaments.edit(t, form))
    }
  }

  def update(id: String) = PlayerAction.async(parse.urlFormEncoded) { implicit request =>
    Tournament.findById(id).flatMap { tournament =>
      request.player match {
        case u: User if tournament.masterId == u.id => {
          tournamentForm.bindFromRequest().fold(
            withErrors => Future.successful(BadRequest(views.html.tournaments.creation(withErrors))),
            {
              case TournamentData(name, meetTime, description) => {
                val updated = tournament.copy(name = name, meetTime = meetTime, description = description)
                Tournament.update(updated).map { _ =>
                  Redirect(routes.Tournaments.show(tournament.id.stringify))
                }
              }
            }
          )
        }
        case _ => Future.successful(Forbidden)
      }
    }
  }

  val raceForm = Form(
    mapping(
      "generator" -> nonEmptyText,
      "startTime" -> optional(jodaDate("yyyy-MM-dd'T'HH:mm"))
    )(TournamentRaceData.apply)(TournamentRaceData.unapply)
  )

  def raceCreation(id: String) = PlayerAction.async() { implicit request =>
    asAdmin { _ =>
      Tournament.findById(id).map { tournament =>
        Ok(views.html.tournaments.raceCreation(tournament, raceForm))
      }
    }
  }

  def createRace(id: String) = PlayerAction.async() { implicit request =>
    Tournament.findById(id).flatMap { tournament =>
      raceForm.bindFromRequest.fold(
        withErrors => Future.successful(BadRequest(views.html.tournaments.raceCreation(tournament, withErrors))),
        {
          case TournamentRaceData(generator, startTime) => {
            val race = Race(
              playerId = Some(request.player.id),
              tournamentId = Some(tournament.id),
              startTime = startTime,
              course = CourseGenerator.all.find(_.slug == generator).getOrElse(Classic).generateCourse(),
              generator = generator
            )
            for {
              _ <- Race.save(race)
            }
            yield Redirect(routes.Tournaments.show(id)).flashing("success" -> Messages("tournaments.raceAdded"))
          }
        }
      )
    }
  }

  def mountRace(id: String, raceId: String) = PlayerAction.async() { implicit request =>
    asAdmin { user =>
      for {
        race <- Race.findById(raceId)
        if race.tournamentId.contains(BSONObjectID(id))
        _ <- RacesSupervisor.actorRef ? MountRace(race, user)
      }
      yield Redirect(routes.Tournaments.show(id)).flashing("success" -> Messages("tournaments.raceMounted"))
    }
  }

  def unmountRace(id: String, raceId: String) = PlayerAction.async() { implicit request =>
    asAdmin { user =>
      for {
        race <- Race.findById(raceId)
        if race.tournamentId.contains(BSONObjectID(id))
        _ <- RacesSupervisor.actorRef ? UnmountRace(race)
      }
      yield Redirect(routes.Tournaments.show(id)).flashing("success" -> Messages("tournaments.raceUnmounted"))
    } 
  }

}
