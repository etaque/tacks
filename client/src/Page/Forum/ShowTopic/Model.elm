module Page.Forum.ShowTopic.Model exposing (..)

import Model.Shared as Shared exposing (Id, User, FormResult, RemoteData(..))
import Page.Forum.Model.Shared exposing (..)
import Http


type alias Model =
    { topicWithPosts : RemoteData Http.Error TopicWithPosts
    , response : Maybe String
    , submitting : Bool
    }


initial : Model
initial =
    { topicWithPosts = Loading
    , response = Nothing
    , submitting = False
    }


type Msg
    = LoadResult (Result Http.Error TopicWithPosts)
    | SetContent String
    | ToggleResponse
    | SubmitResponse
    | SubmitResponseResult (FormResult PostWithUser)
    | NoOp
