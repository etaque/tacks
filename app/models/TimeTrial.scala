package models

import scala.util.Try
import java.util.UUID
import org.joda.time._


case class TimeTrial(
  id: UUID,
  trackId: UUID,
  period: String,
  creationTime: DateTime
)

object TimeTrial {
  val countdown = 15

  val periodFormat = "YYYY-MM"

  def currentPeriod =
    LocalDate.now.toString(periodFormat)

  def parsePeriod(p: String): LocalDate =
    Try(LocalDate.parse(p)).toOption.getOrElse(LocalDate.now)

  def isOpen(t: TimeTrial) =
    t.period == currentPeriod
}
