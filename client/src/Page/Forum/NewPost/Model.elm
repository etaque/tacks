module Page.Forum.NewPost.Model where

import Model.Shared exposing (Id, User, FormResult)
import Page.Forum.Model.Shared exposing (..)


type alias Model =
  { topic : Topic
  , content : String
  }


type Action
  = SetContent String
  | Submit
  | SubmitResult (FormResult PostWithUser)

