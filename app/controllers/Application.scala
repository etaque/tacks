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
import models.JsonFormats._

object Application extends Controller with Security {

  def index = PlayerAction.async() { implicit request =>
    for {
      finishedRaces     <- Race.listFinished(10)
      users             <- User.listByIds(finishedRaces.flatMap(_.tally.map(_.playerId)))
      timeTrials        <- TimeTrial.listCurrent
      trialsWithRanking <- TimeTrial.zipWithRankings(timeTrials)
      trialsUsers       <- User.listByIds(trialsWithRanking.flatMap(_._2.map(_.playerId)))
      leaderboard        = TimeTrialLeaderboard.forTrials(trialsWithRanking, trialsUsers)
    }
    yield Ok(views.html.index(timeTrials, trialsUsers, leaderboard, finishedRaces, users, Users.userForm))
  }

  def setHandle = PlayerAction(parse.urlFormEncoded) { implicit request =>
    val handleOpt = request.body.get("handle").flatMap(_.headOption).filter(_.nonEmpty)
    handleOpt match {
      case Some(handle) => Redirect(routes.Application.index()).addingToSession("playerHandle" -> handle)
      case None => Redirect(routes.Application.index()).removingFromSession("playerHandle")
    }

  }

  def notFound(path: String) = PlayerAction.async() { implicit request =>
    Future.successful(NotFound(views.html.notFound()))
  }

  implicit val timeout = Timeout(5.seconds)

  def showHelp(implicit request: PlayerRequest[_]): Boolean = {
   request.player match {
     case u: User => false
     case g: Guest => false
   }
  }

  def playTimeTrial(timeTrialId: String) = PlayerAction.async() { implicit request =>
    TimeTrial.findById(timeTrialId).map { timeTrial =>
      val wsUrl = routes.WebSockets.timeTrial(timeTrial.idToStr).webSocketURL()
      val initialInput = Json.toJson(RaceUpdate.initial)
      val gameSetup = Json.toJson(GameSetup(request.player, timeTrial.course, timeTrial = true))
      Ok(views.html.game(gameSetup, initialInput, wsUrl, showHelp))
    }
  }

  def playRace(raceId: String) = PlayerAction.async() { implicit request =>
    (RacesSupervisor.actorRef ? GetRace(BSONObjectID(raceId))).mapTo[Option[Race]].map {
      case None => NotFound
      case Some(race) => {
        val wsUrl = routes.WebSockets.racePlayer(race.idToStr).webSocketURL()
        val initialInput = Json.toJson(RaceUpdate.initial)
        val gameSetup = Json.toJson(GameSetup(request.player, race.course, timeTrial = false))
        Ok(views.html.game(gameSetup, initialInput, wsUrl, showHelp))
      }
    }
  }

  def tutorial = PlayerAction() { implicit request =>
    val wsUrl = routes.WebSockets.tutorial().webSocketURL()
    val messages = JsMessages.filtering(_.startsWith("tutorial")).messages
    val initialInput = Json.toJson(TutorialUpdate.initial(request.player, messages))
    Ok(views.html.tutorial(wsUrl, initialInput))
  }
}

