module Page.ShowProfile.Model where

import Model.Shared exposing (..)


type alias Screen =
  { player : Player
  }

initial : Player -> Screen
initial player =
  { player = player }

type Action
  = NoOp

