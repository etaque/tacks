module Page.Forum.Index.Model exposing (..)

import Page.Forum.Model.Shared exposing (..)


type alias Model =
  { topics : List TopicWithUser }


initial : Model
initial =
  { topics = [] }


type Msg
  = ListResult (Result () (List TopicWithUser))
  | RefreshList
  | NoOp
