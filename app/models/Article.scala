package models

import io.prismic.{Document, Fragment}

import dao.PrismicDAO

case class Article(title: String, body: Fragment.StructuredText)

object Article extends PrismicDAO[Article] {
  val docType = "article"

  def fromDoc(doc: Document): Option[Article] = {
    for {
      title <- doc.getText("article.title")
      body <- doc.getStructuredText("article.content")
    }
    yield Article(title, body)
  }

}
