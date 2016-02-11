module Page.Register.Model where

import Regex exposing (Regex)
import Form exposing (Form)
import Form.Validate exposing (..)
import Dict exposing (Dict)

import Model.Shared exposing (..)


type alias Screen =
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
    ("handle" := string `andThen` (\s -> format s handleFormat))
    ("email" := email)
    ("password" := string `andThen` minLength 4)


handleFormat : Regex
handleFormat =
  Regex.regex "^\\w{3,20}$"


initial : Screen
initial =
  { form = Form.initial [] validation
  , loading = False
  , serverErrors = Dict.empty
  }

type Action
  = FormAction Form.Action
  | Submit NewPlayer
  | SubmitResult (FormResult Player)
  | NoOp
