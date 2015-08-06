module Screens.Register.RegisterTypes where

import Models exposing (..)


type alias Screen =
  { handle : String
  , email : String
  , password : String
  , error : Bool
  }


type Action
  = SetHandle String
  | SetEmail String
  | SetPassword String
  | Submit
  | Success Player
  | Error
  | NoOp
