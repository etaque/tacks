module Page.Forum.Index.Model exposing (..)

import Page.Forum.Model.Shared exposing (..)
import Http


type alias Model =
    { topics : List TopicWithUser }


initial : Model
initial =
    { topics = [] }


type Msg
    = ListResult (Result Http.Error (List TopicWithUser))
    | RefreshList
    | NoOp
