module Page.Forum.Model where

import Page.Forum.Route exposing (..)
import Page.Forum.Model.Shared exposing (..)
import Page.Forum.NewTopic.Model as NewTopic
import Page.Forum.NewPost.Model as NewPost


type alias Model =
  { topics : List TopicWithUser
  , currentTopic : Maybe TopicWithPosts
  , newTopic : Maybe NewTopic.Model
  , newPost : Maybe NewPost.Model
  }


initialRoute : Route
initialRoute =
  Index


initial : Model
initial =
  { topics = []
  , currentTopic = Nothing
  , newTopic = Nothing
  , newPost = Nothing
  }


type Action
  = ListResult (Result () (List TopicWithUser))
  | ShowResult (Result () (TopicWithPosts))
  | RefreshList
  | ToggleNewTopic
  | ToggleNewPost
  | NewTopicAction NewTopic.Action
  | NewPostAction NewPost.Action
  | NoOp

