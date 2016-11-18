module Page.Forum.ShowTopic.Model exposing (..)

import Model.Shared exposing (Id, User, FormResult)
import Page.Forum.Model.Shared exposing (..)
import Http


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
    = LoadResult (Result Http.Error TopicWithPosts)
    | SetContent String
    | ToggleNewPost
    | Submit
    | SubmitResult (FormResult PostWithUser)
    | NoOp
