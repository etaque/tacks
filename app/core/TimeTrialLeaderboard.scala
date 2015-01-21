package core

import models._
import reactivemongo.bson.BSONObjectID

//import scala.concurrent.Future
//
//case class Leaderboard(
//  trials: Seq[TimeTrial],
//  lines: Seq[LeaderboardLine]
//)
//
//case class LeaderboardLine(
//  user: User,
//  rank: Int,
//  total: Int,
//  scores: Seq[LeaderboardScore]
//)
//
//case class LeaderboardScore(
//  points: Int,
//  run: TimeTrialRun,
//  ranking: RunRanking
//)

object Leaderboard {

  type TrialWithRankings = (TimeTrial, Seq[(TimeTrialRun, RunRanking)])
  type Points = Int
  type Run = TimeTrialRun
  type Ranking = RunRanking
//
//  def apply(trials: Seq[TimeTrial]): Future[Leaderboard] = {
//    for {
//      withRankings <- TimeTrial.zipWithRankings(trials)
//    }
//
//    Leaderboard(trials, Nil)
//  }


//  def zipWithLeaderboard(trialsWithRankings: Seq[(TimeTrial, Seq[(TimeTrialRun, RunRanking)])]): Seq[(TimeTrial, Leaderboard)] = {
//    trialsWithRankings.map {
//      case (trial, rankings) => (trial, forTrial(trial, rankings))
//    }
//  }


//  def ranked(items: Seq[(Run, Ranking, Points)]) = {
//    items.sortBy(_._3).reverse.zipWithIndex.map {
//      case ((run, ranking, points), i) => (i + 1, playerId, playerHandle, points)
//    }
//  }
}





object TimeTrialLeaderboard {

  type PlayerId = BSONObjectID
  type Points = Int
  type Leaderboard = Seq[(Int, PlayerId, Points)]

  def forTrials(trialsWithRankings: Seq[(TimeTrial, Seq[RunRanking])], users: Seq[User]): Leaderboard = {
//    val userRankings = trialsWithRankings.map { case (trial, runsWithRankings) =>
//      (trial, runsWithRankings.filter { ranking =>
//          userIds.contains(ranking.playerId)
//      })
//    }
    globalLeaderboard(leaderboardByTrial(trialsWithRankings, users).map(_._2))
  }

  def leaderboardByTrial(trialsWithRankings: Seq[(TimeTrial, Seq[RunRanking])], users: Seq[User]): Seq[(TimeTrial, Leaderboard)] = {
    val userIds = users.map(_.id)
    trialsWithRankings.map {
      case (trial, rankings) => {
        val usersRankings = rankings.filter { ranking =>
          // exclude guests for leaderboard
          userIds.contains(ranking.playerId)
        }.zipWithIndex.map { case (ranking, i) =>
          // re-rank as we dropped guests
          ranking.copy(rank = i + 1)
        }
        (trial, forTrial(trial, usersRankings))
      }
    }
  }

  def globalLeaderboard(leaderboards: Seq[Leaderboard]): Leaderboard = {
    val items = leaderboards.flatten.groupBy(_._2).map {
      case (playerId, idsWithPoints) => {
        val total = idsWithPoints.map(_._3).sum
        (playerId, total)
      }
    }.toSeq
    ranked(items)
  }

  def forTrial(timeTrial: TimeTrial, rankings: Seq[RunRanking]): Leaderboard = {
    val items = rankings.map {
      case RunRanking(rank, playerId, _, _, _) => {
        (playerId, rankings.length - rank + 1)
      }
    }
    ranked(items)
  }

  def ranked(items: Seq[(PlayerId, Points)]): Leaderboard = {
    items.sortBy(_._2).reverse.zipWithIndex.map {
      case ((playerId, points), i) => (i + 1, playerId, points)
    }
  }

}
