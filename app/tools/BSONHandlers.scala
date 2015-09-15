package tools

import org.joda.time.DateTime
import reactivemongo.bson._

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
}
