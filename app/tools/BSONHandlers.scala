package tools

import org.joda.time.DateTime
import reactivemongo.bson._
import scala.util.Try

object BSONHandlers {

  implicit object BSONDateTimeHandler extends BSONHandler[BSONDateTime, DateTime] {
    def read(time: BSONDateTime) = new DateTime(time.value)
    def write(jdtime: DateTime) = BSONDateTime(jdtime.getMillis)
  }

  implicit def tupleHandler[A, BSONA <: BSONValue, B, BSONB <: BSONValue]
    (implicit aHandler: BSONHandler[BSONA, A], bHandler: BSONHandler[BSONB, B]) =

    new BSONHandler[BSONArray, (A, B)] {
      def read(array: BSONArray) =
        (array.getAs[A](0).get, array.getAs[B](1).get)

      def write(tuple: (A, B)) =
        BSONArray(Seq(aHandler.write(tuple._1), bHandler.write(tuple._2)))
    }

  implicit def seqHandler[A, BSONA <: BSONValue](implicit handler: BSONHandler[BSONA, A]) = new BSONHandler[BSONArray, Seq[A]] {
    def read(array: BSONArray) = array.values.collect {
      case a: BSONA => handler.read(a)
    }
    def write(aSeq: Seq[A]) = BSONArray(aSeq.map(handler.write))
  }

  implicit val rangeHandler = new BSONHandler[BSONDocument, Range] {
    def read(doc: BSONDocument) = (doc.getAs[Int]("start"), doc.getAs[Int]("end")) match {
      case (Some(start), Some(end)) => Range(start, end)
      case _ => sys.error("Unexpected Range value: " + doc)
    }
    def write(range: Range) = BSONDocument("start" -> BSONInteger(range.start), "end" -> BSONInteger(range.end))
  }

  def enumHandler[E <: Enumeration](enum: E) = new BSONHandler[BSONString, E#Value] {
    def read(bs: BSONString) =
      bs.seeAsOpt[BSONString].flatMap { case BSONString(s) =>
        Try(enum.withName(s)).toOption
      }.getOrElse(sys.error("Unexpected TrackStatus value: " + bs))

    def write(e: E#Value): BSONString = BSONString(e.toString)
  }


}
