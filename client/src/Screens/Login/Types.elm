module Screens.Login.Types where

import Models exposing (..)


type alias Screen =
  { email : String
  , password : String
  , error : Bool
  }


type Action
  = SetEmail String
  | SetPassword String
  | Submit
  | Success Player
  | Error
  | NoOp

