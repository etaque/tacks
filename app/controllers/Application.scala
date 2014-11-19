package controllers

import scala.concurrent.Future
import scala.concurrent.duration._
import play.api.libs.concurrent.Execution.Implicits._
import play.api.mvc._
import play.api.Play.current
import akka.util.Timeout
import akka.pattern.{ ask, pipe }
import reactivemongo.bson.BSONObjectID

import actors.{GetRace, RacesSupervisor}
import models.{TimeTrialRun, TimeTrial, User, Race}

object Application extends Controller with Security {

  def index = Identified.async() { implicit request =>
    val jsMessages = jsmessages.api.JsMessages.default
    for {
      finishedRaces <- Race.listFinished(10)
      users <- User.listByIds(finishedRaces.flatMap(_.tally.map(_.playerId)))
      timeTrials <- TimeTrial.list
      trialsWithRanking <- Future.sequence(timeTrials.map(t => TimeTrialRun.ranking(t.id).map(r => (t, r))))
      trialsUsers <- User.listByIds(trialsWithRanking.flatMap(_._2.map(_._1)))
    }
    yield Ok(views.html.index(request.player, trialsWithRanking, trialsUsers, finishedRaces, users, Users.userForm, jsMessages))
  }

  implicit val timeout = Timeout(5.seconds)

  def playTimeTrial(timeTrialId: String) = Identified.async() { implicit request =>
    TimeTrial.findById(timeTrialId).map { timeTrial =>
      val wsUrl = routes.Api.timeTrialSocket(timeTrial.idToStr).webSocketURL()
      Ok(views.html.playTimeTrial(timeTrial, wsUrl))
    }
  }

  def playRace(raceId: String) = Identified.async() { implicit request =>
    (RacesSupervisor.actorRef ? GetRace(BSONObjectID(raceId))).mapTo[Option[Race]].map {
      case None => NotFound
      case Some(race) => {
        val wsUrl = routes.Api.racePlayerSocket(race.idToStr).webSocketURL()
        Ok(views.html.playRace(race, wsUrl))
      }
    }
  }

  def watchRace(raceId: String) = Identified.async() { implicit request =>
    (RacesSupervisor.actorRef ? GetRace(BSONObjectID(raceId))).mapTo[Option[Race]].map {
      case None => NotFound
      case Some(race) => {
        val wsUrl = routes.Api.raceWatcherSocket(race.idToStr).webSocketURL()
        Ok(views.html.watchRace(race, wsUrl))
      }
    }
  }
}

