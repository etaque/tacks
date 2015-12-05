module Screens.ShowProfile.Types where

import Models exposing (..)


type alias Screen =
  { player : Player
  }

initial : Player -> Screen
initial player =
  { player = player }

type Action
  = NoOp

