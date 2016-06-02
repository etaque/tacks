package tools

import scala.util.Try

import play.api.data.validation.ValidationError
import play.api.libs.json._
import play.api.libs.functional.syntax._
import play.api.libs.concurrent.Execution.Implicits._

import org.joda.time.DateTime


object JsonFormats {

  implicit val doubleOptionFormat = Format.optionWithNull[Double]

  // DateTime <-> Mongo Date

  implicit val dateTimeReads: Reads[DateTime] =
    __.read[Long].map(new DateTime(_))

  implicit val dateTimeWrites: Writes[DateTime] = new Writes[DateTime] {
    def writes(dateTime: DateTime): JsValue =
      JsNumber(dateTime.getMillis)
  }

  implicit val dateTimeFormat: Format[DateTime] = Format(dateTimeReads, dateTimeWrites)


  // Tuple2

  implicit def tuple2Reads[A, B](implicit aReads: Reads[A], bReads: Reads[B]): Reads[(A, B)] = Reads[(A, B)] {
    case JsArray(arr) if arr.size == 2 => for {
      a <- aReads.reads(arr(0))
      b <- bReads.reads(arr(1))
    } yield (a, b)
    case _ => JsError(Seq(JsPath() -> Seq(ValidationError("Expected array of two elements"))))
  }

  implicit def tuple2Writes[A, B](implicit aWrites: Writes[A], bWrites: Writes[B]): Writes[(A, B)] =
    new Writes[(A, B)] {
      def writes(tuple: (A, B)) = JsArray(Seq(aWrites.writes(tuple._1), bWrites.writes(tuple._2)))
    }

  implicit def tuple2Format[A,B](implicit aFormat: Format[A], bFormat: Format[B]): Format[(A,B)] =
    Format[(A,B)](tuple2Reads[A,B], tuple2Writes[A,B])

  // Scala Enumeration

  implicit def mapReads[K, V](implicit valueReads: Reads[V]): Reads[Map[K, V]] = Reads[Map[K, V]] {
    case JsObject(fields) => {
      val res = fields.flatMap {
        case (key, value) => for {
          k <- Try(key.asInstanceOf[K]).toOption
          v <- valueReads.reads(value).asOpt
        } yield k -> v
      }.toMap
      JsSuccess(res)
    }
    case _ => JsSuccess(Map.empty)
  }

  implicit def mapWrites[K, V](implicit valueWrites: Writes[V]): Writes[Map[K, V]] =
    new Writes[Map[K, V]] {
      def writes(kv: Map[K, V]) = JsObject(kv.map { case (k, v) => k.toString -> valueWrites.writes(v) }.toSeq)
    }

  implicit def mapFormat[K, V](implicit vFormat: Format[V]): Format[Map[K, V]] =
    Format[Map[K, V]](mapReads[K, V], mapWrites[K, V])

  def enumReads[E <: Enumeration](enum: E): Reads[E#Value] = new Reads[E#Value] {
    def reads(json: JsValue): JsResult[E#Value] = json match {
      case JsString(s) => {
        try {
          JsSuccess(enum.withName(s))
        }
        catch { case _: NoSuchElementException =>
          JsError(s"Enumeration expected of type: '${enum.getClass}', but it does not appear to contain the value: '$s'")
        }
      }
      case _ => JsError("String value expected")
    }
  }

  def enumWrites[E <: Enumeration]: Writes[E#Value] = new Writes[E#Value] {
    def writes(v: E#Value): JsValue = JsString(v.toString)
  }

  def enumFormat[E <: Enumeration](enum: E): Format[E#Value] = {
    Format(enumReads(enum), enumWrites)
  }


  implicit val rangeWrites: Writes[Range] = Writes { range: Range =>
    Json.obj("start" -> range.start, "end" -> range.end)
  }

  implicit val rangeReads: Reads[Range] = (
    (__ \ 'start).read[Int] and (__ \ 'end).read[Int]
  )(Range(_, _))

  implicit val rangeFormat: Format[Range] = Format(rangeReads, rangeWrites)

  val timestampFormat: Format[Long] =
    Format(Reads.FloatReads.map(_.round.toLong), Writes.LongWrites)

  val timestampSeqFormat: Format[Seq[Long]] =
    Format(Reads.seq(timestampFormat), Writes.seq(timestampFormat))

}
