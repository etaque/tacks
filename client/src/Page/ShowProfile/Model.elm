module Page.ShowProfile.Model where

import Model.Shared exposing (..)


type alias Model =
  { player : Player
  }

initial : Player -> Model
initial player =
  { player = player }

type Action
  = NoOp

