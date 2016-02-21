module Page.Forum.Model where

import Page.Forum.Route exposing (..)
import Page.Forum.Model.Shared exposing (..)
import Page.Forum.NewTopic.Model as NewTopic
import Page.Forum.NewPost.Model as NewPost


type alias Model =
  { topics : List TopicWithUser
  , currentTopic : Maybe TopicWithPosts
  , newTopic : NewTopic.Model
  , newPost : Maybe NewPost.Model
  }


initialRoute : Route
initialRoute =
  Index


initial : Model
initial =
  { topics = []
  , currentTopic = Nothing
  , newTopic = { title = "", content = "" }
  , newPost = Nothing
  }


type Action
  = ListResult (Result () (List TopicWithUser))
  | ShowResult (Result () (TopicWithPosts))
  | RefreshList
  | ToggleNewPost
  | NewTopicAction NewTopic.Action
  | NewPostAction NewPost.Action
  | AppendPost PostWithUser
  | NoOp

