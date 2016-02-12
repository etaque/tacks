package dao

import com.github.tminglei.slickpg._
import java.sql.Timestamp
import org.joda.time.DateTime
import play.api.Play
import play.api.db.slick.DatabaseConfigProvider
import scala.concurrent.Future
import slick.dbio.DBIO
import slick.driver.JdbcProfile


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
  }
}

object DB extends DB {
  val dbConfig = DatabaseConfigProvider.get[JdbcProfile]("default")(Play.current)

  def run[A](a: DBIO[A]): Future[A] = {
    dbConfig.db.run(a)
  }
}
