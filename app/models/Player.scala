package models

import org.joda.time.DateTime
import org.mindrot.jbcrypt.BCrypt
import reactivemongo.bson._
import play.api.libs.concurrent.Execution.Implicits._
import reactivemongo.core.commands.LastError
import tools.Conf
import scala.concurrent.Future
import tools.future.Implicits._
import tools.BSONHandlers.BSONDateTimeHandler

sealed trait Player {
  val _id: BSONObjectID
  def id: BSONObjectID

  def vmgMagnet: Int
  def handleOpt: Option[String]
  def isAdmin: Boolean
}

trait WithPlayer {
  def playerId: BSONObjectID
  def playerHandle: Option[String]

  def playerTuple = (playerId, playerHandle)

  def playerAsGuest = Guest(playerId, playerHandle)
  def findPlayer(users: Seq[User]): Player = users.find(_.id == playerId) match {
    case Some(user) => user
    case None => playerAsGuest
  }
}

object Player {

  val defaultVmgMagnet = 15

  // implicit val bsonHandler = new BSONHandler[BSONDocument, Player] {
  //   def read(bson: BSONDocument) = bson.getAs[String]("email") match {
  //     case Some(_) => User.bsonReader.read(bson)
  //     case None => Guest.bsonHandler.read(bson)
  //   }
  //   def write(player: Player) = player match {
  //     case u: User => User.bsonWriter.write(u)
  //     case g: Guest => Guest.bsonHandler.write(g)
  //   }
  // }
}

case class User(
  _id: BSONObjectID = BSONObjectID.generate,
  email: String,
  handle: String,
  status: Option[String],
  avatarId: Option[BSONObjectID],
  vmgMagnet: Int = Player.defaultVmgMagnet,
  creationTime: DateTime = DateTime.now
) extends Player with HasId {
  def handleOpt = Some(handle)
  def isAdmin = Conf.adminHandles.contains(handle)
}

// case class CreateUser(email: String, password: String, handle: String)

case class Guest(
  _id: BSONObjectID = BSONObjectID.generate,
  handle: Option[String] = None
) extends Player with HasId {
  val vmgMagnet = Player.defaultVmgMagnet
  def handleOpt = handle
  val isAdmin = false
}

object Guest {
  // implicit val bsonHandler = Macros.handler[Guest]
}
