package models

import org.mindrot.jbcrypt.BCrypt
import reactivemongo.bson._
import play.api.libs.concurrent.Execution.Implicits._
import scala.concurrent.Future
import tools.future.Implicits._

sealed trait Player {
  val _id: BSONObjectID
  def id: BSONObjectID
}

object Player {

  implicit val bsonHandler = new BSONHandler[BSONDocument, Player] {
    def read(bson: BSONDocument) = bson.getAs[String]("email") match {
      case Some(_) => User.bsonReader.read(bson)
      case None => Guest.bsonHandler.read(bson)
    }
    def write(player: Player) = player match {
      case u: User => User.bsonWriter.write(u)
      case g: Guest => Guest.bsonHandler.write(g)
    }
  }
}

case class User(
  _id: BSONObjectID = BSONObjectID.generate,
  email: String,
  handle: String,
  name: Option[String]
) extends Player with HasId { }

case class CreateUser(email: String, password: String, handle: String)

object User extends MongoDAO[User] {
  val collectionName = "users"

  def create(user: User, password: String): Future[_] = {
    val userBson = bsonWriter.write(user)
    val doc = userBson ++ BSONDocument("password" -> makePasswordHash(password))

    collection.insert(doc)
  }

  def findByEmail(email: String): Future[Option[User]] = {
    collection.find(BSONDocument("email" -> email)).one[User]
  }

  def findByHandle(email: String): Future[Option[User]] = {
    collection.find(BSONDocument("handle" -> email)).one[User]
  }

  private def makePasswordHash(password: String): String = {
    val hashRounds = 12
    BCrypt.hashpw(password, BCrypt.gensalt(hashRounds))
  }

  /** Checks that a user inputted password matches a stored hash given a stored salt **/
  def checkPassword(inputedPassword: String)(storedHash: String): Boolean = {
    BCrypt.checkpw(inputedPassword, storedHash)
  }

  def getHashedPassword(email: String): Future[String] = {
    val query = BSONDocument("email" -> email)
    val result = collection.find(query).cursor[BSONDocument].headOption
    result.map(_.flatMap(_.getAs[String]("password"))).flattenOpt
  }

  def updateName(id: BSONObjectID, nameOption: Option[String]): Future[_] = nameOption match {
    case Some(n) => update(id, BSONDocument("name" -> n))
    case None => unset(id, BSONDocument("name" -> true))

  }

  def ensureIndexes(): Unit = {
    import reactivemongo.api.indexes.Index
    import reactivemongo.api.indexes.IndexType._

    collection.indexesManager.ensure(Index(
      key = List("email" -> Ascending),
      unique = true))

    collection.indexesManager.ensure(Index(
      key = List("handle" -> Ascending),
      unique = true))
  }

  implicit val bsonReader: BSONDocumentReader[User] = Macros.reader[User]
  implicit val bsonWriter: BSONDocumentWriter[User] = Macros.writer[User]
}

case class Guest(_id: BSONObjectID) extends Player with HasId

object Guest {
  implicit val bsonHandler = Macros.handler[Guest]
}
