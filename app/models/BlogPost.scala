package models

import io.prismic.{Document, Fragment}
import org.joda.time.LocalDate

case class BlogPost(
  id: String,
  slug: String,
  title: String,
  date: LocalDate,
  body: Fragment.StructuredText
)

object BlogPost extends PrismicDAO[BlogPost] {
  val docType = "blog"

  def fromDoc(doc: Document): Option[BlogPost] = {
    for {
      title <- doc.getText("blog.title")
      body <- doc.getStructuredText("blog.body")
      date <- doc.getDate("blog.date").map(_.value)
    }
    yield BlogPost(
      id = doc.id,
      slug = doc.slug,
      title = title,
      date = date,
      body = body
    )
  }

}
