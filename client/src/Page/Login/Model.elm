module Page.Login.Model exposing (..)

import Model.Shared exposing (..)


type alias Model =
    { email : String
    , password : String
    , loading : Bool
    , error : Bool
    }


initial : Model
initial =
    { email = ""
    , password = ""
    , loading = False
    , error = False
    }


type Msg
    = SetEmail String
    | SetPassword String
    | Submit
    | SubmitResult (FormResult Player)
    | NoOp
