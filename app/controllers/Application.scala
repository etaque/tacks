package controllers

import scala.concurrent.duration._
import play.api.libs.concurrent.Execution.Implicits._
import play.api.mvc._
import play.api.Play.current
import akka.util.Timeout
import akka.pattern.{ ask, pipe }
import reactivemongo.bson.BSONObjectID

import actors.{GetRace, RacesSupervisor}
import models.{User, Race}

object Application extends Controller with Security {

  def index = Identified.async() { implicit request =>
    val jsMessages = jsmessages.api.JsMessages.default
    for {
      finishedRaces <- Race.listFinished(10)
      users <- User.listByIds(finishedRaces.flatMap(_.tally.map(_.playerId)))
    }
    yield Ok(views.html.index(request.player, finishedRaces, users, Users.userForm, jsMessages))
  }

  implicit val timeout = Timeout(5.seconds)

  def playRace(raceId: String) = Identified.async() { implicit request =>
    (RacesSupervisor.actorRef ? GetRace(BSONObjectID(raceId))).mapTo[Option[Race]].map {
      case None => NotFound
      case Some(race) => {
        val wsUrl = routes.Api.playerSocket(race.idToStr).webSocketURL()
        Ok(views.html.playRace(race, wsUrl))
      }
    }
  }

}

