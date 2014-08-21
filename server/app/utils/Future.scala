package utils

//import scala.util.{ Success, Failure, Try }
import scala.concurrent.{ Future, Promise }
import play.api.libs.concurrent.Execution.Implicits._


case class FutureFlattenOptException(message: String) extends RuntimeException(message)

/**
* Implicit Extension methods for futures
*/
object Implicits {


  implicit class RichFutureOfOpt[T](val target: Future[Option[T]]) extends AnyVal {

    /**
    * Converts a Future[Option[A]] to a Future[A]
    * Use when the error handling is not that granular or important and a failed future
    * or a successful future of None are handled similarly.
    */
    def flattenOpt(errorMessage: String): Future[T] = {
      target.filter(_.isDefined).map(_.get).transform(
        value => value,
        error => error match {
          case e: NoSuchElementException => new FutureFlattenOptException(errorMessage)
          case e => e
        }
      )
    }

    def flattenOpt: Future[T] = flattenOpt("Some expected, received None")
  }

}