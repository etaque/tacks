module Page.Forum.Decoders where

import Json.Decode as Json exposing (..)

import Decoders exposing (userDecoder)
import Page.Forum.Model exposing (..)


topicWithUserDecoder =
  object2 TopicWithUser
    ("topic" := topicDecoder)
    ("user" := userDecoder)


topicDecoder =
  object5 Topic
    ("id" := string)
    ("title" := string)
    ("postsCount" := int)
    ("creationTime" := float)
    ("activityTime" := float)


postWithUserDecoder =
  object2 PostWithUser
    ("post" := postDecoder)
    ("user" := userDecoder)


postDecoder =
  object4 Post
    ("id" := string)
    ("content" := string)
    ("creationTime" := float)
    ("updateTime" := float)


topicWithPostsDecoder =
  object2 TopicWithPosts
    ("topic" := topicDecoder)
    ("postsWithUsers" := list postWithUserDecoder)
