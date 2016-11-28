module Page.Register.Model exposing (..)

import Regex exposing (Regex)
import Form exposing (Form)
import Form.Validate exposing (..)
import Dict exposing (Dict)
import Model.Shared exposing (..)


type alias Model =
    { form : Form () NewPlayer
    , loading : Bool
    , serverErrors : Dict String (List String)
    }


type alias NewPlayer =
    { handle : String
    , email : String
    , password : String
    }


validation : Validation () NewPlayer
validation =
    map3 NewPlayer
        (field "handle" (string |> andThen (format handleFormat)))
        (field "email" email)
        (field "password" (string |> andThen (minLength 4)))


handleFormat : Regex
handleFormat =
    Regex.regex "^\\w{3,20}$"


initial : Model
initial =
    { form = Form.initial [] validation
    , loading = False
    , serverErrors = Dict.empty
    }


type Msg
    = FormMsg Form.Msg
    | SubmitResult (FormResult Player)
