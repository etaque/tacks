package models

import java.util.UUID
import org.joda.time.DateTime


case class ForumPost(
  id: UUID,
  title: Option[String],
  parentId: Option[UUID],
  userId: UUID,
  content: String,
  creationTime: DateTime,
  updateTime: DateTime
)
