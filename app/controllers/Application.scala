package controllers

import scala.concurrent.Future
import scala.concurrent.duration._
import play.api.libs.concurrent.Execution.Implicits._
import play.api.mvc._
import play.api.Play.current
import play.api.libs.json.Json
import akka.util.Timeout
import akka.pattern.ask
import reactivemongo.bson.BSONObjectID
import jsmessages.api.JsMessages

import core.TimeTrialLeaderboard
import actors.{GetRace, RacesSupervisor}
import models._

object Application extends Controller with Security {

  def index = PlayerAction.async() { implicit request =>
    for {
      finishedRaces     <- Race.listFinished(10)
      users             <- User.listByIds(finishedRaces.flatMap(_.tally.map(_.playerId)))
      timeTrials        <- TimeTrial.listCurrent
      trialsWithRanking <- TimeTrial.zipWithRankings(timeTrials)
      leaderboard       = TimeTrialLeaderboard.forTrials(trialsWithRanking)
      trialsUsers       <- User.listByIds(trialsWithRanking.flatMap(_._2.map(_.playerId)))
    }
    yield Ok(views.html.index(request.player, trialsWithRanking, trialsUsers, leaderboard, finishedRaces, users, Users.userForm))
  }

  def notFound(path: String) = PlayerAction.async() { implicit request =>
    Future.successful(NotFound(views.html.notFound()))
  }

  implicit val timeout = Timeout(5.seconds)
  import models.JsonFormats.raceUpdateFormat

  def playTimeTrial(timeTrialId: String) = PlayerAction.async() { implicit request =>
    TimeTrial.findById(timeTrialId).map { timeTrial =>
      val wsUrl = routes.Api.timeTrialSocket(timeTrial.idToStr).webSocketURL()
      val initialInput = Json.toJson(RaceUpdate.initial(request.player, timeTrial.course, timeTrial = true))
      Ok(views.html.game(initialInput, wsUrl))
    }
  }

  def playRace(raceId: String) = PlayerAction.async() { implicit request =>
    (RacesSupervisor.actorRef ? GetRace(BSONObjectID(raceId))).mapTo[Option[Race]].map {
      case None => NotFound
      case Some(race) => {
        val wsUrl = routes.Api.racePlayerSocket(race.idToStr).webSocketURL()
        val initialInput = Json.toJson(RaceUpdate.initial(request.player, race.course))
        Ok(views.html.game(initialInput, wsUrl))
      }
    }
  }

  def watchRace(raceId: String) = PlayerAction.async() { implicit request =>
    (RacesSupervisor.actorRef ? GetRace(BSONObjectID(raceId))).mapTo[Option[Race]].map {
      case None => NotFound
      case Some(race) => {
        val wsUrl = routes.Api.raceWatcherSocket(race.idToStr).webSocketURL()
        val initialInput = Json.toJson(RaceUpdate.initial(request.player, race.course, watching = true))
        Ok(views.html.game(initialInput, wsUrl))
      }
    }
  }

  import models.JsonFormats.tutorialUpdateFormat

  def tutorial = PlayerAction.apply() { implicit request =>
    val wsUrl = routes.Api.tutorialSocket().webSocketURL()
    val messages = JsMessages.filtering(_.startsWith("tutorial")).messages
    val initialInput = Json.toJson(TutorialUpdate.initial(request.player, messages))
    Ok(views.html.tutorial(wsUrl, initialInput))
  }
}

