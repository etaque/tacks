module Page.Forum.ShowTopic.Model where

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



type Action
  = LoadResult (Result () (TopicWithPosts))
  | SetContent String
  | ToggleNewPost
  | Submit
  | SubmitResult (FormResult PostWithUser)
  | NoOp

