package controllers

import core.{WarmUp, CourseGenerator}
import play.api.libs.concurrent.Execution.Implicits._
import scala.concurrent.Future
import scala.concurrent.duration._
import play.api.mvc._
import play.api.mvc.WebSocket.FrameFormatter
import play.api.libs.json._
import play.api.libs.functional.syntax._
import play.api.Play.current
import akka.actor.ActorRef
import akka.util.Timeout
import akka.pattern.{ ask, pipe }
import org.joda.time.DateTime
import reactivemongo.bson.BSONObjectID

import actors._
import models._
import models.JsonFormats._
import tools.future.Implicits._

import scala.util.Try

object Api extends Controller with Security {

  implicit val timeout = Timeout(5.seconds)

  implicit val loginReads = (
    (__ \ "email").read[String] and
      (__ \ "password").read[String]
    ).tupled

  def login = Action.async(parse.json) { implicit request =>
    request.body.validate(loginReads).fold(
      errors => Future.successful(BadRequest),
      {
        case (email, password) => {
          (for {
            credentials <- User.getHashedPassword(email).map(User.checkPassword(password))
            if credentials
            user <- User.findByEmail(email).flattenOpt
          }
          yield {
            Ok.withSession("playerId" -> user.idToStr)
          }) recover {
            case _ => BadRequest
          }
        }
      }
    )
  }

  def racesStatus = PlayerAction.async() { implicit request =>
    val racesFuture = (RacesSupervisor.actorRef ? GetOpenRaces).mapTo[Seq[RaceStatus]]
    val onlinePlayersFuture = (ChatRoom.actorRef ? GetOnlinePlayers).mapTo[Seq[Player]]
    for {
      openRaces <- racesFuture
      onlinePlayers <- onlinePlayersFuture
    }
    yield Ok(Json.obj(
      "now" -> DateTime.now,
      "openRaces" -> Json.toJson(openRaces),
      "onlinePlayers" -> Json.toJson(onlinePlayers),
      "generators" -> Json.toJson(CourseGenerator.all.map(_.slug))
    ))
  }

  def onlinePlayers = PlayerAction.async() { implicit request =>
    (ChatRoom.actorRef ? GetOnlinePlayers).mapTo[Seq[Player]].map { players =>
      Ok(Json.toJson(players))
    }
  }

  def createRace(generatorSlug: String) = PlayerAction.async(parse.json) { implicit request =>
    val generator = CourseGenerator.findBySlug(generatorSlug).getOrElse(WarmUp)

    val countdown = request.getQueryString("countdown")
      .flatMap(c => Try(c.toInt).toOption)
      .getOrElse(60)

    val race = Race(
      playerId = getPlayerId,
      course = generator.generateCourse(),
      generator = generator.slug,
      countdownSeconds = countdown
    )

    (RacesSupervisor.actorRef ? MountRace(race, request.player)).map { _ =>
      Ok(Json.toJson(race))
    }
  }

  def setName = PlayerAction(parse.json) { implicit request =>
    (request.body \ "name").asOpt[String] match {
      case Some(name) => Ok(Json.obj()).addingToSession("playerName" -> name)
      case None => BadRequest
    }
  }

  def currentUser = PlayerAction() { implicit request =>
    Ok(Json.toJson(request.player))
  }

  implicit val playerInputFrameFormatter = FrameFormatter.jsonFrame[PlayerInput]
  implicit val watcherInputFrameFormatter = FrameFormatter.jsonFrame[WatcherInput]
  implicit val raceUpdateFrameFormatter = FrameFormatter.jsonFrame[RaceUpdate]

  def timeTrialSocket(timeTrialId: String) = WebSocket.tryAcceptWithActor[PlayerInput, RaceUpdate] { implicit request =>
    for {
      player <- PlayerAction.getPlayer(request)
      timeTrial <- TimeTrial.findById(timeTrialId)
      run = TimeTrialRun(timeTrialId = timeTrial.id, playerId = player.id)
      ghostRuns <- TimeTrialRun.findGhosts(timeTrial, run)
      timeTrialActor <- (RacesSupervisor.actorRef ? MountTimeTrialRun(timeTrial, player, run)).mapTo[ActorRef]
    }
    yield {
      timeTrialActor ! SetGhostRuns(ghostRuns)
      Right(PlayerActor.props(timeTrialActor, player)(_))
    }
  }

  def racePlayerSocket(raceId: String) = WebSocket.tryAcceptWithActor[PlayerInput, RaceUpdate] { implicit request =>
    PlayerAction.getPlayer(request).flatMap { player =>
      (RacesSupervisor.actorRef ? GetRaceActorRef(BSONObjectID(raceId))).mapTo[Option[ActorRef]].map {
        case Some(raceActor) => Right(PlayerActor.props(raceActor, player)(_))
        case None => Left(NotFound)
      }
    }
  }

  def raceWatcherSocket(raceId: String) = WebSocket.tryAcceptWithActor[WatcherInput, RaceUpdate] { implicit request =>
    PlayerAction.getPlayer(request).flatMap { watcher =>
      (RacesSupervisor.actorRef ? GetRaceActorRef(BSONObjectID(raceId))).mapTo[Option[ActorRef]].map {
        case Some(raceActor) => Right(WatcherActor.props(raceActor, watcher)(_))
        case None => Left(NotFound)
      }
    }
  }

  implicit val tutorialInputFrameFormatter = FrameFormatter.jsonFrame[TutorialInput]
  implicit val tutorialUpdateFormatter = FrameFormatter.jsonFrame[TutorialUpdate]

  def tutorialSocket = WebSocket.tryAcceptWithActor[TutorialInput, TutorialUpdate] { implicit request =>
    for {
      player <- PlayerAction.getPlayer(request)
      ref <- (RacesSupervisor.actorRef ? MountTutorial(player)).mapTo[ActorRef]
    }
    yield {
      Right(PlayerActor.props(ref, player)(_))
    }
  }

}
