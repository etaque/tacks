package views.timeTrials

import models.{Player, RunRanking}

case class RankingExtract(
  inWindow: Seq[RunRanking],
  outOfWindow: Option[RunRanking] = None
)

object RankingExtract {

  def make(rankings: Seq[RunRanking], p: Player, windowMaybe: Option[Int]): RankingExtract = {

    windowMaybe.map { window =>
      val top = rankings.take(window)

      rankings.find(_.playerId == p.id) match {
        case Some(playerRanking) => {
          if (top.exists(_.playerId == p.id)) RankingExtract(top)
          else RankingExtract(rankings.take(window - 1), Some(playerRanking))
        }
        case _ => RankingExtract(top)
      }
    }.getOrElse(RankingExtract(rankings))
  }

}
