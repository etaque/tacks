package actors

import java.util.UUID
import play.api.Logger
import scala.concurrent.duration._
import scala.concurrent.Future
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.concurrent.Execution.Implicits._
import play.api.libs.json._
import akka.actor._
import akka.pattern.pipe
import fly.play.s3._
import models._
import models.JsonFormats._
import scala.util.Try
import tools.Gzip

object PathStoreAction {
  sealed trait Action

  case class Save(run: Run, slices: RunPath.Slices) extends Action
  case class Get(run: Run) extends Action
  case class Delete(run: Run) extends Action
}

class PathStore extends Actor {
  import PathStoreAction._

  def receive = {
    case Save(run, slices) =>
      PathStore.save(run, slices)

    case Get(run) =>
      PathStore.get(run).pipeTo(sender)

    case Delete(run) =>
      PathStore.delete(run)
  }
}

object PathStore {
  val actorRef = Akka.system.actorOf(Props[PathStore])
  val bucket = S3(tools.Conf.s3.bucket)

  def filename(run: Run): String = {
    val handle = run.playerHandle.getOrElse("anonymous")
    s"${run.trackId}/$handle-${run.id}.gz"
  }

  def save(run: Run, slices: RunPath.Slices): Try[Future[Unit]] = {
    Logger.info("Preparing path for save...")
    Gzip.deflate(Json.stringify(Json.toJson(slices))).map { content =>
      Logger.info("Path deflated, uploading to S3...")
      val file = BucketFile(filename(run), "gzip", content.getBytes)
      bucket.add(file).map { _ =>
        Logger.info(s"S3 upload success for file ${file.name}.")
      }.recover { case e =>
        Logger.error(s"S3 upload error for file ${file.name}: ${e.getMessage}")
      }
    }
  }

  def get(run: Run): Future[Option[RunPath.Slices]] = {
    Logger.info("Fetching from S3: " + filename(run))
    bucket.get(filename(run)).map { file =>
      Logger.info("Fetch successful, inflating...")
      for {
        content <- Gzip.inflate(new String(file.content.map(_.toChar))).toOption
        slices <- Json.parse(content).asOpt[Seq[(Long, Seq[PathPoint])]].map(_.toMap)
        _ = Logger.info(s"Path successfully inflated and parsed: ${slices.size} slices.")
      } yield slices
    }
  }

  def delete(run: Run): Future[Unit] = {
    bucket.remove(filename(run))
  }

}
