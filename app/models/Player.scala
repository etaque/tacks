package models

import java.util.UUID
import org.joda.time.DateTime
import org.mindrot.jbcrypt.BCrypt
import play.api.libs.concurrent.Execution.Implicits._

import tools.Conf
import scala.concurrent.Future
import tools.future.Implicits._


sealed trait Player {
  def id: UUID

  def vmgMagnet: Int
  def handleOpt: Option[String]
  def isAdmin: Boolean
}

trait WithPlayer {
  def playerId: UUID
  def playerHandle: Option[String]
}

object Player {
  val defaultVmgMagnet = 15
}

case class User(
  id: UUID = UUID.randomUUID(),
  email: String,
  handle: String,
  status: Option[String],
  // avatarId: Option[BSONObjectID],
  vmgMagnet: Int = Player.defaultVmgMagnet,
  creationTime: DateTime = DateTime.now
) extends Player {
  def handleOpt = Some(handle)
  def isAdmin = Conf.adminHandles.contains(handle)

  def gravatarHash: String = {
    val md5 = java.security.MessageDigest.getInstance("md5")
    md5.digest(email.toLowerCase.trim.getBytes).map("%02x".format(_)).mkString
  }
}

case class Guest(
  id: UUID = UUID.randomUUID(),
  handle: Option[String] = None
) extends Player {
  val vmgMagnet = Player.defaultVmgMagnet
  def handleOpt = handle
  val isAdmin = false
}

