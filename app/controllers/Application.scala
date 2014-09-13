package controllers

import play.api.mvc._

object Application extends Controller {

  def index(url: String) = Action { implicit request =>
    Ok(views.html.index())
  }

}

