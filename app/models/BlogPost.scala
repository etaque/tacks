package models

import io.prismic.{Document, Fragment}

case class BlogPost(
  id: String,
  slug: String,
  title: String,
  body: Fragment.StructuredText
)

object BlogPost extends PrismicDAO[BlogPost] {
  val docType = "blog"

  def fromDoc(doc: Document): Option[BlogPost] = {
    for {
      title <- doc.getText("blog.title")
      body <- doc.getStructuredText("blog.body")
    }
    yield BlogPost(
      id = doc.id,
      slug = doc.slug,
      title = title,
      body = body
    )
  }

}
