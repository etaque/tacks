module Page.Login.Model where

import Models exposing (..)


type alias Screen =
  { email : String
  , password : String
  , loading : Bool
  , error : Bool
  }

initial : Screen
initial =
  { email = ""
  , password = ""
  , loading = False
  , error = False
  }

type Action
  = SetEmail String
  | SetPassword String
  | Submit
  | SubmitResult (FormResult Player)
  | NoOp

