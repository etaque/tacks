package models.forum

import java.util.UUID
import org.joda.time.DateTime
import org.joda.time.DateTime

import models.User


case class Topic(
  id: UUID,
  title: String,
  postId: Option[UUID],
  postsCount: Int,
  creationTime: DateTime,
  activityTime: DateTime
)

case class UiTopic(
  topic: Topic,
  user: User
)
