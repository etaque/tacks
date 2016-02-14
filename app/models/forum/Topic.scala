package models.forum

import java.util.UUID


case class Topic(
  id: UUID,
  title: String,
  postId: Option[UUID]
)

case class TopicWithOriginal(
  topic: Topic,
  post: Post,
  user: models.User
)
