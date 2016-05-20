module Page.Forum.ShowTopic.Model exposing (..)

import Model.Shared exposing (Id, User, FormResult)
import Page.Forum.Model.Shared exposing (..)


type alias Model =
  { currentTopic : Maybe TopicWithPosts
  , newPostContent : Maybe String
  , loading : Bool
  }


initial : Model
initial =
  { currentTopic = Nothing
  , newPostContent = Nothing
  , loading = False
  }



type Msg
  = LoadResult (Result () (TopicWithPosts))
  | SetContent String
  | ToggleNewPost
  | Submit
  | SubmitResult (FormResult PostWithUser)
  | NoOp

