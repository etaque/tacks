module Screens.ShowTrack.Types where

import Models exposing (..)


type alias Screen =
  { track : Maybe Track
  , notFound : Bool
  }


type Action
  = SetTrack Track
  | TrackNotFound
  | NoOp

