package dao

import java.util.UUID
import scala.concurrent.Future
import org.joda.time.DateTime
import play.api.libs.json._

import DB.api._
import models._
import models.JsonFormats.pathSliceFormat


class RunPathTable(tag: Tag) extends Table[RunPath](tag, "run_paths") {

  implicit val slicesColumn =
    MappedColumnType.base[Map[Long, Seq[PathPoint]], JsValue](
      slices => Json.toJson(slices.toSeq),
      _.as[Seq[(Long, Seq[PathPoint])]].toMap
    )

  def id = column[UUID]("id", O.PrimaryKey)
  def runId = column[UUID]("run_id")
  def slices = column[Map[Long, Seq[PathPoint]]]("slices")

  def * = (id, runId, slices) <> ((RunPath.apply _).tupled, RunPath.unapply)
}

object RunPaths extends TableQuery(new RunPathTable(_)) {
  def save(runPath: RunPath): Future[Int] = DB.run {
    map(identity) += runPath
  }

  def findByRunId(runId: UUID): Future[Option[RunPath]] = DB.run {
    onRunId(runId).result.headOption
  }

  def deleteByRunId(runId: UUID) = DB.run {
    onRunId(runId).delete
  }

  private def onRunId(runId: UUID) =
    filter(_.runId === runId)
}
