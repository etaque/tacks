package dao

import java.sql.JDBCType
import java.sql.Timestamp
import java.util.UUID
import org.joda.time.DateTime
import scala.concurrent.Future
import play.api.Play
import play.api.db.slick.DatabaseConfigProvider
import slick.dbio.DBIO
import slick.driver.JdbcProfile
import slick.jdbc.{ PositionedParameters, PositionedResult, SetParameter }
import com.github.tminglei.slickpg._
import org.joda.time.DateTime


trait DB extends ExPostgresDriver
    with PgDateSupportJoda
    with PgArraySupport
    with PgPlayJsonSupport {

  def pgjson = "jsonb"

  override val api = LocaleAPI

  object LocaleAPI extends API
      with DateTimeImplicits
      with PlayJsonImplicits
      with PlayJsonPlainImplicits
      with JsonImplicits
      with SimpleArrayPlainImplicits {

    implicit class PgPositionedResult(val r: PositionedResult) {
      def nextUUID: UUID = UUID.fromString(r.nextString)
      def nextUUIDOption: Option[UUID] = r.nextStringOption().map(UUID.fromString)
      def nextLongSeq: Seq[Long] = r.nextJson.asOpt[Seq[Long]].getOrElse(Nil)
    }

    implicit object SetUUID extends SetParameter[UUID] {
      def apply(v: UUID, pp: PositionedParameters) {
        pp.setObject(v, JDBCType.BINARY.getVendorTypeNumber)
      }
    }

    implicit object SetJodaDateTime extends SetParameter[DateTime] {
      def apply(v: DateTime, pp: PositionedParameters) {
        pp.setObject(new java.sql.Timestamp(v.getMillis), java.sql.Types.TIMESTAMP)
      }
    }
  }
}

object DB extends DB {
  val dbConfig = DatabaseConfigProvider.get[JdbcProfile]("default")(Play.current)

  def run[A](a: DBIO[A]): Future[A] = {
    dbConfig.db.run(a)
  }
}
