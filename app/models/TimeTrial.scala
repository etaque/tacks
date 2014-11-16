package models

import play.api.libs.concurrent.Execution.Implicits._
import org.joda.time.{LocalDate, DateTime}
import reactivemongo.bson._
import tools.BSONHandlers.BSONDateTimeHandler

import scala.concurrent.Future

case class TimeTrial(
  _id: BSONObjectID = BSONObjectID.generate,
  time: DateTime,
  course: Course,
  countdownSeconds: Int
) extends HasId

object TimeTrial extends MongoDAO[TimeTrial] {
  val collectionName = "time_trials"

  def currentDay = LocalDate.now.toDateTimeAtStartOfDay

  def createForPeriod() = {
    val q = BSONDocument("time" -> BSONDocument("$gte" -> currentDay))
    collection.find(q).one[TimeTrial].filter(_.isEmpty).foreach { _ =>
      save(TimeTrial(time = currentDay, course = Course.spawn, countdownSeconds = 60))
    }
  }

  def findCurrent: Future[Option[TimeTrial]] = {
    collection.find(BSONDocument()).sort(BSONDocument("time" -> -1)).one[TimeTrial]
  }

  implicit val bsonReader: BSONDocumentReader[TimeTrial] = Macros.reader[TimeTrial]
  implicit val bsonWriter: BSONDocumentWriter[TimeTrial] = Macros.writer[TimeTrial]
}


case class TimeTrialRun(
  _id: BSONObjectID = BSONObjectID.generate,
  timeTrialId: BSONObjectID,
  playerId: BSONObjectID,
  tally: Seq[Long] = Nil,
  finishTime: Option[Long] = None
) extends HasId

object TimeTrialRun extends MongoDAO[TimeTrialRun] {
  val collectionName = "time_trial_runs"

  def updateTimes(id: BSONObjectID, tally: Seq[Long], finishTime: Option[Long]): Future[_] = {
    update(id, BSONDocument("tally" -> tally, "finishTime" -> finishTime))
  }

  implicit val bsonReader: BSONDocumentReader[TimeTrialRun] = Macros.reader[TimeTrialRun]
  implicit val bsonWriter: BSONDocumentWriter[TimeTrialRun] = Macros.writer[TimeTrialRun]
}


