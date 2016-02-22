module Page.Forum.Index.Model where

import Page.Forum.Model.Shared exposing (..)


type alias Model =
  { topics : List TopicWithUser }


initial : Model
initial =
  { topics = [] }


type Action
  = ListResult (Result () (List TopicWithUser))
  | RefreshList
  | NoOp
