package controllers

import play.api.libs.concurrent.Execution.Implicits._
import models.{User, TimeTrialRun, TimeTrial}
import play.api.mvc.Controller

object TimeTrials extends Controller with Security  {

  def show(id: String) = Identified.async() { implicit request =>
    for {
      trial <- TimeTrial.findById(id)
      rankings <- TimeTrialRun.rankings(trial.id)
      users <- User.listByIds(rankings.map(_.playerId))
    }
    yield Ok(views.html.timeTrials.show(trial, rankings, users))
  }
}
