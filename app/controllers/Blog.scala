package controllers

import io.prismic.{Fragment, DocumentLinkResolver, Api => PrismicApi}
import play.api.libs.concurrent.Execution.Implicits._
import play.api.mvc.Controller
import models.BlogPost

object Blog extends Controller with Security with Prismic {

  def makeLinkResolver(prismicApi: PrismicApi) = DocumentLinkResolver(prismicApi) {
    case (Fragment.DocumentLink(id, typ, tags, slug, _), _) => routes.Blog.show(id, slug).url
    case _ => routes.Blog.index().url
  }

  def index = PlayerAction.async() { implicit request =>
    for {
      api <- apiBuilder
      posts <- BlogPost.listAll()(api)
    }
    yield Ok(views.html.blog.index(posts, makeLinkResolver(api)))
  }

  def show(id: String, slug: String) = PlayerAction.async() { implicit request =>
    for {
      api <- apiBuilder
      postOption <- BlogPost.findByIdOpt(id)(api)
    }
    yield postOption match {
      case Some(post) => Ok(views.html.blog.show(post, makeLinkResolver(api)))
      case None => NotFound
    }
  }

}
