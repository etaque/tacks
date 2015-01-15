package views

import org.joda.time.{Interval, DateTime}
import play.api.i18n.{Messages, Lang}

object Helpers {

  def round3(n: Double): Double = math.round(n * 1000) * 0.001

  def timer(t: Long): String = {
    val c = math.ceil(t / 1000).toInt
    val m = math.floor(c / 60).toInt
    val s = "%02d".format(c % 60)
    val ms = "%03d".format(t % 1000)
    s"$m:$s.$ms"
  }

  def timeDelta(t: Long): String = {
    val s = t / 1000
    val ms = "%03d".format(t % 1000)
    s"+ $s.$ms"
  }

  def rankSuffixKey(r: Int): String = r match {
    case 1 => "rank.first"
    case 2 => "rank.second"
    case _ => "rank.nth"
  }

  def timeAgo(t: DateTime)(implicit l: Lang) = {
    val seconds = (DateTime.now.getMillis - t.getMillis) / 1000
    if (seconds < 60) {
      Messages("secondsAgo", seconds)

    } else {
      val minutes = seconds / 60
      if (minutes < 60) {
        if (minutes == 1) Messages("minuteAgo")
        else Messages("minuteAgo", minutes)

      } else {
        val hours = minutes / 60
        if (hours < 24) {
          if (hours == 1) Messages("hourAgo")
          else Messages("hoursAgo", hours)

        } else {
          val days = hours / 24
          if (days == 1) Messages("dayAgo")
          else Messages("daysAgo", days)
        }
      }
    }
  }
}
