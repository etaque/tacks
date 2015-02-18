package core

import models._
import reactivemongo.bson.BSONObjectID


object TimeTrialLeaderboard {

  type PlayerId = BSONObjectID
  type Points = Int
  type Leaderboard = Seq[(Int, PlayerId, Points)]

//  def forRaces(races: Seq[Race], users: Seq[User]): Leaderboard = {
//    globalLeaderboard(leaderboardByRace(races).map(_._2))
//  }
//
//  def leaderboardByRace(races: Seq[Race]): Seq[(Race, Leaderboard)] = {
//    races.map { race =>
//      (race, forRace(race))
//    }
//  }
//
//  def forRace(race: Race): Leaderboard = {
//    val items = race.rankings.map {
//      case RaceRanking(rank, playerId, _, _) => {
//        (playerId, race.rankings.length - rank + 1)
//      }
//    }
//    ranked(items)
//  }

  def forTrials(trialsWithRankings: Seq[(TimeTrial, Seq[RunRanking])], users: Seq[User]): Leaderboard = {
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
