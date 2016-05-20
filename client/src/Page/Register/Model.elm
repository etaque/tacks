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
  form3 NewPlayer
    (get "handle" (string `andThen` (format handleFormat)))
    (get "email" email)
    (get "password" (string `andThen` minLength 4))


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
  | Submit NewPlayer
  | SubmitResult (FormResult Player)
  | NoOp
