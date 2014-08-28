package controllers

import reactivemongo.bson.BSONObjectID

import scala.collection.mutable.ListBuffer
import scala.concurrent.duration._
import scala.concurrent.ExecutionContext.Implicits.global
import play.api.mvc._
import play.api.mvc.WebSocket.FrameFormatter
import play.api.Play.current
import akka.actor.{Props, ActorRef}
import akka.util.Timeout
import akka.pattern.{ ask, pipe }
import org.joda.time.DateTime

import actors._
import models._

object Races extends Controller {

  implicit val timeout = Timeout(5.seconds)

  def show(id: String) = Action.async { implicit req =>
    (RacesSupervisor.actorRef ? GetRace(BSONObjectID(id))).map {
      case Some(race: Race) => {
        val websocketUrlBase = "ws://" + req.host
        val nameMaybe = req.getQueryString("name")
        val res = Ok(views.html.showRace(race, nameMaybe, websocketUrlBase))

        nameMaybe.map(n => res.withSession("playerName" -> n)).getOrElse(res)

      }
      case None => Redirect(routes.Application.index())
    }
  }

  import models.JsonFormats._
  implicit val boatUpdateFrameFormatter = FrameFormatter.jsonFrame[BoatState]
  implicit val raceUpdateFrameFormatter = FrameFormatter.jsonFrame[RaceUpdate]

  def gameSocket(raceId: String, playerId: String) = WebSocket.tryAcceptWithActor[BoatState, RaceUpdate] { request =>
    (RacesSupervisor.actorRef ? GetRaceActor(BSONObjectID(raceId))).map {
      case Some(raceActor: ActorRef) => Right(PlayerActor.props(raceActor, playerId)(_))
      case None => Left(NotFound)
    }
  }
}

