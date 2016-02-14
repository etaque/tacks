package models.forum

import java.util.UUID
import org.joda.time.DateTime

import models.User


case class Post(
  id: UUID,
  topicId: UUID,
  userId: UUID,
  content: String,
  creationTime: DateTime,
  updateTime: DateTime
)

case class PostWithUser(
  post: Post,
  user: User
)

