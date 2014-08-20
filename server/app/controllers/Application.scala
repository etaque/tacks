package controllers

import scala.collection.mutable.ListBuffer
import scala.concurrent.Future
import scala.concurrent.duration._
import scala.concurrent.ExecutionContext.Implicits.global
import play.api.libs.concurrent.Akka
import play.api.mvc._
import play.api.mvc.WebSocket.FrameFormatter
import play.api.Play.current
import akka.actor.{Props, ActorRef}
import akka.util.Timeout
import akka.pattern.{ ask, pipe }
import org.joda.time.DateTime

import actors._
import models._

object Application extends Controller {

  val supervisor = Akka.system.actorOf(Props[RacesSupervisor])

  var racesStore = ListBuffer[Race](Race(id = "1", startTime = Some(DateTime.now().plusMinutes(1))))

  def index = Action {
    Ok(views.html.index(racesStore.toSeq))
  }

  def showRace(id: String) = Action { implicit req =>
    racesStore.find(_.id == id) match {
      case Some(race) => {
        val websocketUrlBase = "ws://" + req.host
        Ok(views.html.showRace(race, websocketUrlBase))

      }
      case None => NotFound
    }
  }

  import models.JsonFormats._
  implicit val boatUpdateFrameFormatter = FrameFormatter.jsonFrame[BoatState]
  implicit val raceUpdateFrameFormatter = FrameFormatter.jsonFrame[RaceUpdate]

  def boatSocket(id: String, raceId: String) = WebSocket.tryAcceptWithActor[BoatState, RaceUpdate] { request =>
    racesStore.find(_.id == raceId) match {
      case None => Future.successful(Left(NotFound))
      case Some(race) => {
        implicit val timeout = Timeout(5 seconds)
        (supervisor ? GetRaceActor(race)).map {
          case raceActor: ActorRef => Right(BoatActor.props(raceActor, id)(_))
          case _ => Left(InternalServerError)
        }
      }
    }

  }
}

