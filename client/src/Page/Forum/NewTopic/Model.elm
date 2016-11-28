module Page.Forum.NewTopic.Model exposing (..)

import Form exposing (Form)
import Form.Validate exposing (..)
import Model.Shared exposing (Id, User, FormResult)
import Page.Forum.Model.Shared exposing (..)


type alias Model =
    { form : Form () NewTopic
    , loading : Bool
    }


type alias NewTopic =
    { title : String
    , content : String
    }


validation : Validation () NewTopic
validation =
    map2 NewTopic
        (field "title" (string |> andThen (minLength 2)))
        (field "content" (string |> andThen (minLength 2)))


initial : Model
initial =
    { form = Form.initial [] validation
    , loading = False
    }


type Msg
    = FormMsg Form.Msg
    | SubmitResult (FormResult Topic)
