package core

import models.{RunRanking, TimeTrial}
import reactivemongo.bson.BSONObjectID

object TimeTrialLeaderboard {

  type PlayerId = BSONObjectID
  type Points = Int
  type Leaderboard = Seq[(Int, PlayerId, Points)]

  def forTrials(trialsWithRankings: Seq[(TimeTrial, Seq[RunRanking])]): Leaderboard = {
    summarize(zipWithLeaderboard(trialsWithRankings).map(_._2))
  }

  def zipWithLeaderboard(trialsWithRankings: Seq[(TimeTrial, Seq[RunRanking])]): Seq[(TimeTrial, Leaderboard)] = {
   trialsWithRankings.map {
      case (trial, rankings) => (trial, forTrial(trial, rankings))
    }
  }

  def summarize(leaderboards: Seq[Leaderboard]): Leaderboard = {
    val items = leaderboards.flatten.groupBy(_._2).map {
      case (playerId, idsWithPoints) => (playerId, idsWithPoints.map(_._3).sum)
    }.toSeq
    ranked(items)
  }

  def forTrial(timeTrial: TimeTrial, rankings: Seq[RunRanking]): Leaderboard = {
    val items = rankings.map {
      case RunRanking(rank, playerId, _, _) => {
        (playerId, rankings.length - rank + 1)
      }
    }
    ranked(items)
  }

  def ranked(items: Seq[(PlayerId, Points)]): Leaderboard = {
    items.sortBy(_._2).reverse.zipWithIndex.map {
      case ((userId, points), i) => (i + 1, userId, points)
    }
  }

}
