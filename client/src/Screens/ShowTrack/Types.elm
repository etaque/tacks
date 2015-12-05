module Screens.ShowTrack.Types where

import Models exposing (..)


type alias Screen =
  { track : Maybe Track
  , notFound : Bool
  }

initial : Screen
initial =
  { track = Nothing
  , notFound = False
  }

type Action
  = LoadTrack (Result () Track)
  | NoOp

