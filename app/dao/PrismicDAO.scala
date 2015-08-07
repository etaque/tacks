package dao

import org.joda.time.{LocalTime, DateTime}

import scala.concurrent.Future
import play.api.libs.concurrent.Execution.Implicits._
import io.prismic.{Predicate, Document, Api}
import tools.future.Implicits._

object Prismic {
  def apiBuilder = Api.get(tools.Conf.prismicApi)
}

trait PrismicDAO[T] {
  val docType: String
  def fromDoc(doc: Document): Option[T]

  lazy val docTypePredicate = Predicate.at("document.type", docType)

  def listAll(predicates: Predicate*)(implicit api: Api): Future[Seq[T]] = {
    api.forms("everything")
      .query(docTypePredicate +: predicates : _*)
      .ref(api.master)
      .submit()
      .map(_.results.flatMap(fromDoc))
  }

  def findByIdOpt(id: String)(implicit api: Api): Future[Option[T]] =
    listAll(Predicate.at("document.id", id)).map(_.headOption)

  def findById(id: String)(implicit api: Api): Future[T] = findByIdOpt(id).flattenOpt

  def findByOptId(idMaybe: Option[String])(implicit api: Api): Future[Option[T]] =
    idMaybe.fold(Future.successful[Option[T]](None))(findByIdOpt)

  def findByIds(ids: Seq[String])(implicit api: Api): Future[Seq[T]] = {
    if (ids.isEmpty) Future.successful(Nil)
    else listAll(Predicate.any("document.id", ids))
  }

}

object PrismicHelpers {

  def getDateTime(doc: io.prismic.WithFragments, dateFragment: String, hourFragment: String, minuteFragment: String): Option[DateTime] = {
    val h = doc.getNumber(hourFragment).map(_.value.toInt).getOrElse(0)
    val m = doc.getNumber(minuteFragment).map(_.value.toInt).getOrElse(0)

    doc.getDate(dateFragment).map(_.value.toDateTime(new LocalTime(h, m)))
  }

}
