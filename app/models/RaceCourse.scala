package models

import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._
import org.joda.time.DateTime
import reactivemongo.bson._
import reactivemongo.core.commands.LastError

import tools.BSONHandlers.BSONDateTimeHandler


case class RaceCourse(
  _id: BSONObjectID,
  course: Course,
  countdown: Int,
  startCycle: Int
) extends HasId

object RaceCourse extends MongoDAO[RaceCourse] {
  val collectionName = "raceCourses"

  implicit val bsonReader: BSONDocumentReader[RaceCourse] = Macros.reader[RaceCourse]
  implicit val bsonWriter: BSONDocumentWriter[RaceCourse] = Macros.writer[RaceCourse]
}
