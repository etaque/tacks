package controllers

import play.api.libs.concurrent.Execution.Implicits._
import play.api.mvc._
import reactivemongo.bson.BSONObjectID

import scala.concurrent.Future

// identify user by session id
case class IdentifiedRequest[A](userId: String, request: Request[A]) extends WrappedRequest(request)

trait Security { this: Controller =>

  def getUserId(implicit request: IdentifiedRequest[_]): BSONObjectID = BSONObjectID(request.userId)
  def getUserName(implicit request: IdentifiedRequest[_]): Option[String] = request.session.get("playerName")

  object Identified {

    def apply[A](bp: BodyParser[A] = parse.anyContent)(f: IdentifiedRequest[A] => Result): Action[A] =
      Action(bp) { implicit request =>
        request.session.get("userId").map(
          x => f(IdentifiedRequest(x, request))
        ).getOrElse {
          val userId = BSONObjectID.generate.stringify
          f(IdentifiedRequest(userId, request)).withSession("userId" -> userId)
        }
      }

    def async[A](bp: BodyParser[A] = parse.anyContent)(f: IdentifiedRequest[A] => Future[Result]): Action[A] =
      Action.async(bp) { implicit request =>
        request.session.get("userId").map(
          x => f(IdentifiedRequest(x, request))
        ).getOrElse {
          val userId = BSONObjectID.generate.stringify
          f(IdentifiedRequest(userId, request)).map(_.withSession("userId" -> userId))
        }
      }
  }

}
