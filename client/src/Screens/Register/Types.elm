module Screens.Register.Types where

import Dict exposing (Dict)

import Models exposing (..)


type alias Screen =
  { handle : String
  , email : String
  , password : String
  , loading : Bool
  , errors : Dict String (List String)
  }

initial : Screen
initial =
  { handle = ""
  , email = ""
  , password = ""
  , loading = False
  , errors = Dict.empty
  }

type Action
  = SetHandle String
  | SetEmail String
  | SetPassword String
  | Submit
  | SubmitResult (FormResult Player)
  | NoOp
