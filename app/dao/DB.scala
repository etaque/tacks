package dao

import java.sql.JDBCType
import java.sql.Timestamp
import java.util.UUID
import scala.concurrent.Future
import play.api.Play
import play.api.db.slick.DatabaseConfigProvider
import slick.dbio.DBIO
import slick.driver.JdbcProfile
import slick.jdbc.{SetParameter, PositionedParameters}
import com.github.tminglei.slickpg._
import org.joda.time.DateTime


trait DB extends ExPostgresDriver
  with PgDateSupport
  with PgDateSupportJoda
  with PgArraySupport
  with PgEnumSupport
  with PgPlayJsonSupport {

  def pgjson = "jsonb"

  override val api = LocaleAPI

  object LocaleAPI extends API
    with DateTimeImplicits
    with ArrayImplicits
    with JsonImplicits {

    implicit val longSeqTypeMapper =
      new SimpleArrayJdbcType[Long]("BIGINT").to(_.toSeq)

    // implicit class PgPositionedResult(val r: PositionedResult) {
    //   def nextUUID: UUID = UUID.fromString(r.nextString)
    //   def nextUUIDOption: Option[UUID] = r.nextStringOption().map(UUID.fromString)
    // }

    implicit object SetUUID extends SetParameter[UUID] {
      def apply(v: UUID, pp: PositionedParameters) {
        pp.setObject(v, JDBCType.BINARY.getVendorTypeNumber)
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
