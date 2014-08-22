package utils

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

  implicit val dateTimeReads: Reads[DateTime] = (
    __.read[Long].map { dateTime =>
      new DateTime(dateTime)
    }
  )

  implicit val dateTimeWrites: Writes[DateTime] = new Writes[DateTime] {
    def writes(dateTime: DateTime): JsValue = JsNumber(dateTime.getMillis)
  }

  implicit val dateTimeFormat: Format[DateTime] = Format(dateTimeReads, dateTimeWrites)


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