package controllers

import core.TimeTrialLeaderboard
import play.api.libs.concurrent.Execution.Implicits._
import models.{User, TimeTrialRun, TimeTrial}
import play.api.mvc.Controller

object TimeTrials extends Controller with Security  {

  def show(id: String) = Identified.async() { implicit request =>
    for {
      trial <- TimeTrial.findById(id)
      rankings <- TimeTrialRun.rankings(trial.id)
      users <- User.listByIds(rankings.map(_.playerId))
      allForSlug <- TimeTrial.listForSlug(trial.slug)
    }
    yield Ok(views.html.timeTrials.show(trial, rankings, users, allForSlug))
  }

  def currentLeaderboard = leaderboard(TimeTrial.currentPeriod)

  def leaderboard(period: String) = Identified.async() { implicit request =>
    val date = TimeTrial.parsePeriod(period)
    for {
      timeTrials <- TimeTrial.listForPeriod(period)
      trialsWithRanking <- TimeTrial.zipWithRankings(timeTrials)
      users <- User.listByIds(trialsWithRanking.flatMap(_._2.map(_.playerId)))
    }
    yield {
      val byTrial = TimeTrialLeaderboard.zipWithLeaderboard(trialsWithRanking)
      val overall = TimeTrialLeaderboard.summarize(byTrial.map(_._2))
      Ok(views.html.timeTrials.leaderboard(byTrial, overall, users, date))
    }
  }
}
