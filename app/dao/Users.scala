package dao

import java.util.UUID
import java.util.UUID
import org.joda.time.DateTime
import play.api.libs.json._
import org.mindrot.jbcrypt.BCrypt

import DB.api._
import models._
import models.JsonFormats.courseFormat
import scala.concurrent.Future


class UserTable(tag: Tag) extends Table[User](tag, "users") {
  def id = column[UUID]("id", O.PrimaryKey)
  def email = column[String]("email")
  def handle = column[String]("handle")
  def status = column[Option[String]]("status")
  def vmgMagnet = column[Int]("vmg_magnet")
  def creationTime = column[DateTime]("creation_time")

  def * = (id, email, handle, status, vmgMagnet, creationTime) <> (User.tupled, User.unapply)
}

object Users extends TableQuery(new UserTable(_)) {

  def list(): Future[Seq[User]] = DB.run {
    all.sortBy(_.creationTime.desc).result
  }

  def findById(id: UUID): Future[Option[User]] = DB.run {
    filter(_.id === id).result.headOption
  }

  def findByEmail(email: String): Future[Option[User]] = DB.run {
    filter(_.email.toLowerCase === email.toLowerCase).result.headOption
  }

  def findByHandle(handle: String): Future[Option[User]] = DB.run {
    filter(_.handle === handle).result.headOption
  }

  def listByIds(ids: Seq[UUID]): Future[Seq[User]] = DB.run {
    filter(_.id inSetBind ids).result
  }

  private def makePasswordHash(password: String): String = {
    val hashRounds = 12
    BCrypt.hashpw(password, BCrypt.gensalt(hashRounds))
  }

  /** Checks that a user inputted password matches a stored hash given a stored salt **/
  def checkPassword(inputedPassword: String)(storedHash: String): Boolean = {
    BCrypt.checkpw(inputedPassword, storedHash)
  }

  def findHashedPassword(email: String): Future[Option[String]] = DB.run {
    sql"SELECT password FROM #${baseTableRow.tableName} WHERE email=$email".as[String].headOption
  }

  def create(user: User, password: String): Future[Int] = DB.run {
    val insert = all += user
    val setPassword = sqlu"""
      UPDATE #${baseTableRow.tableName}
      SET password=${makePasswordHash(password)}
      WHERE email=${user.email}"""

    insert.andThen(setPassword).transactionally
  }

  def all =
    map(identity)
}
