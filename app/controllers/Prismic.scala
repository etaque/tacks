package controllers

import io.prismic.{Fragment, DocumentLinkResolver, Api => PrismicApi}
import play.api.libs.concurrent.Execution.Implicits._
import play.api.mvc.Controller
import models.{Article, BlogPost}

object Prismic extends Controller with Security {

  def apiBuilder = io.prismic.Api.get(tools.Conf.prismicApi)

  def makeLinkResolver(prismicApi: PrismicApi) = DocumentLinkResolver(prismicApi) {
    case (Fragment.DocumentLink(id, typ, tags, slug, _), _) => routes.Prismic.post(id, slug).url
    case _ => routes.Prismic.blog().url
  }

  def blog = PlayerAction.async() { implicit request =>
    for {
      api <- apiBuilder
      posts <- BlogPost.listAll()(api)
    }
    yield Ok(views.html.prismic.blog(posts, makeLinkResolver(api)))
  }

  def post(id: String, slug: String) = PlayerAction.async() { implicit request =>
    for {
      api <- apiBuilder
      postOption <- BlogPost.findByIdOpt(id)(api)
    }
    yield postOption match {
      case Some(post) => Ok(views.html.prismic.post(post, makeLinkResolver(api)))
      case None => NotFound(views.html.notFound())
    }
  }

  def about = PlayerAction.async() { implicit request =>
    val name = request2lang.language match {
      case "fr" => "about-fr"
      case _ => "about-en"
    }
    bookmark(name)
  }

  def bookmark(name: String)(implicit req: PlayerRequest[_]) = {
    for {
      api <- apiBuilder
      optId = api.bookmarks.get(name)
      optArticle <- Article.findByOptId(optId)(api)
    }
    yield optArticle match {
      case Some(article) => Ok(views.html.prismic.article(article, makeLinkResolver(api)))
      case None => NotFound(views.html.notFound())
    }
  }
}
