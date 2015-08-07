package controllers

import scala.concurrent.Future
import models.{Guest, Player, User}
import play.api.libs.concurrent.Execution.Implicits._
import play.api.mvc._
import reactivemongo.bson.BSONObjectID

import tools.future.FutureFlattenOptException
import dao._


case class PlayerRequest[A](player: Player, request: Request[A]) extends WrappedRequest(request)

trait Security { this: Controller =>

  def getPlayerId(implicit request: PlayerRequest[_]): BSONObjectID = request.player.id

  def asUser[A](f: User => Future[Result])(implicit req: PlayerRequest[A]): Future[Result] = {
    req.player match {
      case u: User => f(u)
      case _ => Future.successful(Redirect(routes.Application.index("")))
    }
  }

  def asAdmin[A](f: User => Future[Result])(implicit req: PlayerRequest[A]): Future[Result] = {
    req.player match {
      case u: User if u.isAdmin => f(u)
      case _ => Future.successful(Forbidden)
    }
  }

  object PlayerAction {

    def getPlayer(implicit request: RequestHeader): Future[Player] = {
      request.session.get("playerId") match {
        case Some(id) => UserDAO.findByIdOpt(id).map {
          case Some(user) => user
          case None => Guest(BSONObjectID(id), request.session.get("playerHandle"))
        }
        case None => Future.successful(Guest(BSONObjectID.generate))
      }
    }

    def apply[A](bp: BodyParser[A] = parse.anyContent)(f: PlayerRequest[A] => Result): Action[A] =
      async(bp)(f andThen Future.successful)

    def async[A](bp: BodyParser[A] = parse.anyContent)(f: PlayerRequest[A] => Future[Result]): Action[A] =
      Action.async(bp) { implicit request =>
        getPlayer.flatMap { player =>
          implicit val playerRequest = PlayerRequest(player, request)
          f(playerRequest).map { result =>
            player match {
              case g: Guest if request.session.get("playerId").isEmpty => result.addingToSession("playerId" -> player.id.stringify)
              case _ => result
            }
          }.recover {
            case e: FutureFlattenOptException => NotFound
          }
        }
      }
  }

}
