package controllers

import java.util.UUID
import play.api.Play
import play.api.db.slick.DatabaseConfigProvider
import play.api.libs.concurrent.Execution.Implicits._
import scala.concurrent.Future
import scala.concurrent.duration._
import play.api.mvc._
import play.api.libs.json._
import play.api.libs.functional.syntax._
import play.api.libs.json.Reads._
import play.api.Play.current
import akka.util.Timeout
import akka.pattern.{ ask, pipe }
import org.joda.time.DateTime
import play.api.i18n.Messages.Implicits._

import actors._
import models._
import dao._
import models.JsonFormats._
import slick.driver.JdbcProfile
import tools.future.Implicits._
import tools.JsonErrors

import scala.util.Try

object Admin extends Controller with Security {

  def index = PlayerAction.async(parse.anyContent) { implicit request =>
    asAdmin { user =>
      for {
        tracks <- dao.Tracks.list
        users <- dao.Users.list
      }
      yield Ok(Json.obj(
        "tracks" -> Json.toJson(tracks),
        "users" -> Json.toJson(users)(fullUserSeqFormat)
      ))
    }
  }
}
