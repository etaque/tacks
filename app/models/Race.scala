package models

import org.joda.time.DateTime
import play.api.libs.json._
import reactivemongo.bson.{BSONDocumentWriter, Macros, BSONDocumentReader, BSONObjectID}

case class Race (
  _id: BSONObjectID = BSONObjectID.generate,
  playerId: BSONObjectID,
  isPrivate: Boolean,
  course: Course,
  countdownSeconds: Int,
  creationTime: DateTime = DateTime.now
) extends HasId

object Race {
//  val collectionName = "races"

//  implicit val bsonReader: BSONDocumentReader[Race] = Macros.reader[Race]
//  implicit val bsonWriter: BSONDocumentWriter[Race] = Macros.writer[Race]

  import utils.JsonFormats.idFormat
  import JsonFormats._
  implicit val mongoFormat: Format[Race] = Json.format[Race]
}
