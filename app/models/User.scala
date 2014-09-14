package models

import play.api.data.validation.ValidationError

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future
import play.api.libs.json._
import reactivemongo.bson.{BSONDocumentWriter, Macros, BSONDocumentReader, BSONObjectID}
import org.mindrot.jbcrypt.BCrypt

import utils.JsonFormats.idFormat

sealed trait Player {
  val _id: BSONObjectID
  def id: BSONObjectID
  val name: String
}

object Player {
  implicit val playerFormat: Format[Player] = new Format[Player] {

    override def writes(p: Player): JsValue = p match {
      case u: User => User.userFormat.writes(u)
      case g: Guest => Guest.guestFormat.writes(g)
    }

    override def reads(json: JsValue): JsResult[Player] = json match {
      case o: JsObject if (o \ "email").asOpt[String].isDefined => User.userFormat.reads(json)
      case o: JsObject => Guest.guestFormat.reads(json)
      case _ @ v => JsError(Seq(JsPath() -> Seq(ValidationError("Expected Player value, got: " + v.toString))))
    }
  }
}

case class User(
  _id: BSONObjectID,
  email: String,
  name: String
) extends Player with HasId {
}

object User extends MongoDAO[User] {
  val collectionName = "users"

  implicit val bsonReader: BSONDocumentReader[User] = Macros.reader[User]
  implicit val bsonWriter: BSONDocumentWriter[User] = Macros.writer[User]

  implicit val userFormat = Json.format[User]
}

case class Guest(_id: BSONObjectID, name: String) extends Player with HasId

object Guest {
  implicit val guestFormat = Json.format[Guest]
}

// case class User(
//   _id: BSONObjectID = BSONObjectID.generate,
//   email: String,
//   password: String,
//   name: String
// ) extends HasId {
//   def testPassword(plainText: String): Boolean = BCrypt.checkpw(plainText, password)
// }

// object User extends MongoDAO[User] {
//   val collectionName = "users"

//   implicit val mongoFormat: Format[User] = Json.format[User]

//   def hashPassword(plain: String): String = BCrypt.hashpw(plain, BCrypt.gensalt())

//   def insertPlain(email: String, password: String, name: String): Future[User] = {
//     val hashed = hashPassword(password)
//     val user = User(email = email, password = hashed, name = name)

//     save(user).map(_ => user)
//   }

//   def findForLogin(email: String, password: String): Future[Option[User]] =
//     findOneBy(Json.obj("email" -> email)).map(_.filter(_.testPassword(password)))

// }
