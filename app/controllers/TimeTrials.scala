package controllers

import core.TimeTrialLeaderboard
import play.api.libs.concurrent.Execution.Implicits._
import models.{RichRun, User, TimeTrialRun, TimeTrial}
import play.api.mvc.Controller

object TimeTrials extends Controller with Security  {

  def show(id: String) = PlayerAction.async() { implicit request =>
    for {
      trial <- TimeTrial.findById(id)
      rankings <- TimeTrialRun.rankings(trial.id)
      users <- User.listByIds(rankings.map(_.playerId))
      allForSlug <- TimeTrial.listForSlug(trial.slug)
      allForPeriod <- TimeTrial.listForPeriod(trial.period)
      lastRuns <- TimeTrialRun.listRecent(trial.id, 10)
      richRuns <- RichRun.fromRuns(lastRuns, Some(trial))
      runsCount <- TimeTrialRun.countForTrial(trial.id)
    }
    yield Ok(views.html.timeTrials.show(trial, rankings, users, allForSlug, allForPeriod, runsCount, richRuns))
  }

  def currentLeaderboard = leaderboard(TimeTrial.currentPeriod)

  def leaderboard(period: String) = PlayerAction.async() { implicit request =>
    val date = TimeTrial.parsePeriod(period)
    for {
      timeTrials <- TimeTrial.listForPeriod(period)
      trialsWithRanking <- TimeTrial.zipWithRankings(timeTrials)
      users <- User.listByIds(trialsWithRanking.flatMap(_._2.map(_.playerId)))
    }
    yield {
      val byTrial = TimeTrialLeaderboard.leaderboardByTrial(trialsWithRanking, users)
      val overall = TimeTrialLeaderboard.globalLeaderboard(byTrial.map(_._2))
      Ok(views.html.timeTrials.leaderboard(trialsWithRanking, byTrial, overall, users, date))
    }
  }
}
