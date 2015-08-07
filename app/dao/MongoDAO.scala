package dao

import reactivemongo.api.collections.default.BSONCollection

import scala.concurrent.Future
import play.api.libs.json._
import play.api.Play.current
import play.modules.reactivemongo.json.BSONFormats
import play.modules.reactivemongo.ReactiveMongoPlugin
import reactivemongo.api.DefaultDB
import reactivemongo.bson.{BSONDocument, BSONDocumentWriter, BSONDocumentReader, BSONObjectID}
import reactivemongo.core.commands.{LastError, Count}
import play.api.libs.concurrent.Execution.Implicits._
import tools.future.Implicits.RichFutureOfOpt
import org.joda.time.DateTime

import models._

trait MongoDAO[T] {
  val collectionName: String

  implicit val bsonReader: BSONDocumentReader[T]
  implicit val bsonWriter: BSONDocumentWriter[T]

  def db: DefaultDB = ReactiveMongoPlugin.db
  def collection = db[BSONCollection](collectionName)

  def count(query: Option[BSONDocument] = None): Future[Int] = {
    db.command(Count(collectionName, query))
  }

  def count: Future[Int] = count(None)

  def save(doc: T): Future[LastError] = {
    collection.insert(doc)
  }

  def remove(id: BSONObjectID): Future[LastError] = {
    val query = BSONDocument("_id" -> id)
    collection.remove(query)
  }

  def remove(id: String): Future[_] = remove(BSONObjectID(id))

  private def updateCommand(id: BSONObjectID, updateDoc: BSONDocument, command: String): Future[LastError] = {
    collection.update(
      selector = BSONDocument("_id" -> id),
      update = BSONDocument(command -> updateDoc)
    )
  }

  def update(id: BSONObjectID, updateDoc: BSONDocument): Future[LastError] = {
    updateCommand(id, updateDoc, "$set")
  }

  def unset(id: BSONObjectID, updateDoc: BSONDocument): Future[LastError] = {
    updateCommand(id, updateDoc, "$unset")
  }

  def push(id: BSONObjectID, updateDoc: BSONDocument): Future[LastError] = {
    updateCommand(id, updateDoc, "$push")
  }

  def pull(id: BSONObjectID, updateDoc: BSONDocument): Future[LastError] = {
    updateCommand(id, updateDoc, "$pull")
  }

  def update(id: String, updateDoc: BSONDocument): Future[LastError] = update(BSONObjectID(id), updateDoc)

  def findByIdOpt(id: BSONObjectID): Future[Option[T]] = {
    val query = BSONDocument("_id" -> id)
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

  def findByOptId(idMaybe: Option[BSONObjectID]): Future[Option[T]] =
    idMaybe.fold(Future.successful[Option[T]](None))(findByIdOpt)

  def listByIds(ids: Seq[BSONObjectID]): Future[Seq[T]] = {
    val query = BSONDocument("_id" -> BSONDocument("$in" -> ids))
    list(query)
  }

  def list(query: BSONDocument = BSONDocument(), sort: BSONDocument = BSONDocument()): Future[Seq[T]] = {
    collection.find(query).sort(sort).cursor[T].collect[Seq]()
  }

  def list: Future[Seq[T]] = list()
}
