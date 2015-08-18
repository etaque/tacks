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


type Action
  = SetHandle String
  | SetEmail String
  | SetPassword String
  | Submit
  | FormSuccess Player
  | FormFailure (Dict String (List String))
  | NoOp
