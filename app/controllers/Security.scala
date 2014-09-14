package controllers

import actors.{Ping, ChatRoom}
import models.{Guest, Player, User}
import play.api.libs.concurrent.Execution.Implicits._
import play.api.mvc._
import reactivemongo.bson.BSONObjectID

import scala.concurrent.Future

case class IdentifiedRequest[A](player: Player, request: Request[A]) extends WrappedRequest(request)

trait Security { this: Controller =>

  def getPlayerId(implicit request: IdentifiedRequest[_]): BSONObjectID = request.player.id
  def getPlayerName(implicit request: IdentifiedRequest[_]): String = request.player.name

  object Identified {

    def getPlayer(implicit request: RequestHeader): Future[Player] = {
      request.session.get("playerId") match {
        case Some(id) => User.findByIdOpt(id).map {
          case Some(user) => user
          case None => Guest(BSONObjectID(id), request.session.get("playerName").getOrElse("Anonymous"))
        }
        case None => Future.successful(Guest(BSONObjectID.generate, request.session.get("playerName").getOrElse("Anonymous")))
      }
    }

    def pingChatRoom(player: Player) = ChatRoom.actorRef ! Ping(player)

    def apply[A](bp: BodyParser[A] = parse.anyContent)(f: IdentifiedRequest[A] => Result): Action[A] =
      Action.async(bp) { implicit request =>
        getPlayer.map { player =>
          pingChatRoom(player)
          f(IdentifiedRequest(player, request)).addingToSession("playerId" -> player.id.stringify)
        }
      }

    def async[A](bp: BodyParser[A] = parse.anyContent)(f: IdentifiedRequest[A] => Future[Result]): Action[A] =
      Action.async(bp) { implicit request =>
        getPlayer.flatMap { player =>
          pingChatRoom(player)
          f(IdentifiedRequest(player, request)).map(_.addingToSession("playerId" -> player.id.stringify))
        }
      }
  }

}
