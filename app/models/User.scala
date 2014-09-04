package models

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future
import play.api.libs.json.{Format, Json}
import reactivemongo.bson.BSONObjectID
import org.mindrot.jbcrypt.BCrypt

import utils.JsonFormats.idFormat

case class User(id: BSONObjectID, name: String)

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