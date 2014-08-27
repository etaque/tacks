package utils

import play.api.data.validation.ValidationError
import play.api.libs.json._
import play.api.libs.concurrent.Execution.Implicits._
import reactivemongo.bson.BSONObjectID
import org.joda.time.DateTime


object JsonFormats {

  implicit val idWrites: Writes[BSONObjectID] = Writes { id: BSONObjectID => JsString(id.stringify) }

  implicit val idReads: Reads[BSONObjectID] = Reads { id: JsValue => id match {
    case JsString(s) => JsSuccess(BSONObjectID(s))
    case _ => JsError("Not a BSONObjectID")
  } }

  implicit val idFormat: Format[BSONObjectID] = Format(idReads, idWrites)


  // DateTime <-> Mongo Date

  implicit val dateTimeReads: Reads[DateTime] = __.read[Long].map(new DateTime(_))

  implicit val dateTimeWrites: Writes[DateTime] = new Writes[DateTime] {
    def writes(dateTime: DateTime): JsValue = JsNumber(dateTime.getMillis)
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

}