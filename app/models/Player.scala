package models

import reactivemongo.bson._

sealed trait Player {
  val _id: BSONObjectID
  def id: BSONObjectID
  val name: String
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
  _id: BSONObjectID,
  email: String,
  name: String
) extends Player with HasId {
}

object User extends MongoDAO[User] {
  val collectionName = "users"

  implicit val bsonReader: BSONDocumentReader[User] = Macros.reader[User]
  implicit val bsonWriter: BSONDocumentWriter[User] = Macros.writer[User]
}

case class Guest(_id: BSONObjectID, name: String) extends Player with HasId

object Guest {
  implicit val bsonHandler = Macros.handler[Guest]
}
