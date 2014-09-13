package models

import scala.concurrent.Future
import play.api.libs.functional.syntax._
import play.api.libs.json._
import play.api.Play.current
import play.modules.reactivemongo.json.BSONFormats
import play.modules.reactivemongo.json.BSONFormats.BSONObjectIDFormat
import play.modules.reactivemongo.json.collection.JSONCollection
import play.modules.reactivemongo.ReactiveMongoPlugin
import reactivemongo.api.DefaultDB
import reactivemongo.bson.BSONObjectID
import reactivemongo.core.commands.{Count, LastError}
import play.api.libs.concurrent.Execution.Implicits._
import org.joda.time.DateTime
import utils.Implicits.RichFutureOfOpt


/**
* Convenience DAO trait for reactivemongo
*/
trait MongoDAO[T] {
  val collectionName: String
  implicit val mongoFormat: Format[T]

  def db: DefaultDB = ReactiveMongoPlugin.db
  def collection: JSONCollection = db[JSONCollection](collectionName)

  def count(query: Option[JsObject] = None): Future[Int] = {
    val queryAsBSON = query.map(q => BSONFormats.BSONDocumentFormat.reads(q).get)

    db.command(Count(collection.name, queryAsBSON))
  }

  def count: Future[Int] = count(None)

  def save(doc: T): Future[LastError] = {
    collection.save(doc)
  }

  def remove(id: BSONObjectID): Future[_] = {
    val query = Json.obj("_id" -> id)
    collection.remove(query)
  }

  def remove(id: String): Future[_] = remove(BSONObjectID(id))

  private def updateCommand(id: BSONObjectID, updateDoc: JsObject, command: String): Future[_] = {
    collection.update(
      selector = Json.obj("_id" -> id),
      update = Json.obj(command -> updateDoc)
    )
  }

  def update(id: BSONObjectID, updateDoc: JsObject): Future[_] = {
    updateCommand(id, updateDoc, "$set")
  }

  def push(id: BSONObjectID, updateDoc: JsObject): Future[_] = {
    updateCommand(id, updateDoc, "$push")
  }

  def pull(id: BSONObjectID, updateDoc: JsObject): Future[_] = {
    updateCommand(id, updateDoc, "$pull")
  }

  def update(id: String, updateDoc: JsObject): Future[_] = update(BSONObjectID(id), updateDoc)

  def findOneBy(query: JsObject): Future[Option[T]] = {
    collection.find(query).one[T]
  }

  def findByIdOpt(id: BSONObjectID): Future[Option[T]] = {
    val query = Json.obj("_id" -> id)
    collection.find(query).one[T]
  }

  def findByIdOpt(id: String): Future[Option[T]] = {
    findByIdOpt(BSONObjectID(id))
  }

  def findById(id: BSONObjectID): Future[T] = {
    findByIdOpt(id).flattenOpt(collection.name.capitalize + " not found for id: " + id.stringify)
  }

  def findById(id: String): Future[T] = {
    findById(BSONObjectID(id))
  }

  def findJsonById(id: BSONObjectID): Future[Option[JsValue]] = {
    val query = Json.obj("_id" -> id)
    collection.find(query).one[JsValue]
  }

  def findAllById(ids: Seq[BSONObjectID]): Future[Seq[T]] = {
    val query = Json.obj("_id" -> Json.obj("$in" -> ids))
    list(query)
  }

  def list(query: JsObject = Json.obj()): Future[Seq[T]] = {
    collection.find(query).cursor[T].collect[Seq]()
  }

  def list: Future[Seq[T]] = list()
}

trait HasId {
  def _id: BSONObjectID
  def id: BSONObjectID = _id
  def idToStr = id.stringify

//  def creationTime = new DateTime(_id.time)
}
