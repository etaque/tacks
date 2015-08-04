package models

import scala.concurrent.Future
import play.api.Play.current
import play.api.libs.concurrent.Execution.Implicits._
import play.modules.reactivemongo.ReactiveMongoPlugin
import reactivemongo.api.gridfs.ReadFile
import reactivemongo.api.{Cursor, DefaultDB}
import reactivemongo.bson.{BSONDocument, BSONObjectID, BSONValue}
import reactivemongo.core.commands.LastError
import reactivemongo.api.gridfs.Implicits._

object Avatar {
  def db: DefaultDB = ReactiveMongoPlugin.db
  val store = new reactivemongo.api.gridfs.GridFS(db, "avatars")

  val contentTypes = Seq("image/jpeg", "image/png")

  def remove(id: BSONObjectID): Future[LastError] = {
    store.remove(id)
  }

  def removeOpt(idOpt: Option[BSONObjectID]): Future[Unit] = {
    idOpt match {
      case Some(id) => remove(id).map(_ => Unit)
      case None => Future.successful(())
    }
  }

  def read(id: BSONObjectID): Cursor[ReadFile[BSONValue]] = {
    store.find[BSONDocument, ReadFile[BSONValue]](BSONDocument("_id" -> id))
  }
}
