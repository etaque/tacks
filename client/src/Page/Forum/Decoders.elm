module Page.Forum.Decoders exposing (..)

import Json.Decode as Json exposing (..)
import Decoders exposing (userDecoder)
import Page.Forum.Model.Shared exposing (..)


(:=) =
    field


topicWithUserDecoder : Decoder TopicWithUser
topicWithUserDecoder =
    map2 TopicWithUser
        ("topic" := topicDecoder)
        ("user" := userDecoder)


topicDecoder : Decoder Topic
topicDecoder =
    map5 Topic
        ("id" := string)
        ("title" := string)
        ("postsCount" := int)
        ("creationTime" := float)
        ("activityTime" := float)


postWithUserDecoder : Decoder PostWithUser
postWithUserDecoder =
    map2 PostWithUser
        ("post" := postDecoder)
        ("user" := userDecoder)


postDecoder : Decoder Post
postDecoder =
    map4 Post
        ("id" := string)
        ("content" := string)
        ("creationTime" := float)
        ("updateTime" := float)


topicWithPostsDecoder : Decoder TopicWithPosts
topicWithPostsDecoder =
    map2 TopicWithPosts
        ("topic" := topicDecoder)
        ("postsWithUsers" := list postWithUserDecoder)
