module Page.Forum.NewTopic.Model where

import Model.Shared exposing (Id, User, FormResult)
import Page.Forum.Model.Shared exposing (..)


type alias Model =
  { title : String
  , content : String
  }


type Action
  = SetTitle String
  | SetContent String
  | Submit
  | SubmitResult (FormResult Topic)

