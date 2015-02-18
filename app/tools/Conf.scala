package tools

import org.joda.time.LocalDate
import play.api.Play.current
import play.api.Play

object Conf {
  private val conf = Play.application.configuration

  val adminHandles = Seq("milox")
  val defaultTimezone = "Europe/Paris"

  val fps = 30
  val frameMillis = 1000 / fps

  val maxCourses = 6

  val earliestTimeTrial = new LocalDate(2014,12,1)

  val serverRacesCountdownSeconds = 10 * 60

  val prismicApi = getString("prismic.api")

  val disqus = getString("disqus")

  private def getValue[A](getter: String => Option[A], key: String): A = getter(key).getOrElse(sys.error(s"Missing config key: $key"))

  private def getString(key: String) = getValue(conf.getString(_), key)
  private def getBoolean(key: String) = getValue(conf.getBoolean, key)
  private def getMilliseconds(key: String) = getValue(conf.getMilliseconds, key)
  private def getInt(key: String) = getValue(conf.getInt, key)
}
