package tools

import controllers.PlayerRequest
import org.joda.time.{LocalDate, DateTime, DateTimeZone}
import play.api.i18n.Lang

/**
* Date formatting for the current user
*/
object DateFormats {


  private def formatCustom(d: LocalDate, format: String)(implicit lang: Lang, request: PlayerRequest[_]) =
    d.toString(format, lang.toLocale)

  private def formatCustom(dt: DateTime, format: String)(implicit lang: Lang, request: PlayerRequest[_]) =
    timezoned(dt).toString(format, lang.toLocale)


  def timezoned(dt: DateTime)(implicit lang: Lang, request: PlayerRequest[_]) =
    dt.toDateTime(DateTimeZone.forID(Conf.defaultTimezone))

  def monthsLocalized(implicit lang: Lang) = {
    val currentDate = new DateTime()
    (1 to 12).map(currentDate.withMonthOfYear(_).toString("MMM", lang.toLocale))
  }

  def formatDate(d: LocalDate)(implicit lang: Lang, request: PlayerRequest[_]) =
    formatCustom(d, "dd MMM yyyy")

  def formatDateFullMonth(d: LocalDate)(implicit lang: Lang, request: PlayerRequest[_]) =
    formatCustom(d, "dd MMMM yyyy")

  def formatMonthYear(d: LocalDate)(implicit lang: Lang,request: PlayerRequest[_]) =
    formatCustom(d, "MMMM yyyy")


  def formatDateTimeInMonth(dt: DateTime)(implicit lang: Lang,request: PlayerRequest[_]) =
    formatCustom(dt, "EEEE d - HH:mm")

  def formatDateTime(dt: DateTime)(implicit lang: Lang,request: PlayerRequest[_]) =
    formatCustom(dt, "dd MMM yyyy HH:mm")

  def formatTime(dt: DateTime)(implicit lang: Lang, request: PlayerRequest[_]) =
    formatCustom(dt, "HH:mm")

  def formatNumericDate(dt: DateTime)(implicit lang: Lang, request: PlayerRequest[_]) =
    formatCustom(dt, "ddMMyyyy")

}
