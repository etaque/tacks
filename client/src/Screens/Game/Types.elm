module Screens.Game.Types where

import Models exposing (..)
import Game.Models exposing (GameState)
import Game.Inputs exposing (GameInput)

type alias Screen =
  { track : Maybe Track
  , gameState : Maybe GameState
  , live : Bool
  , notFound : Bool
  }


type Action
  = SetTrack Track
  | TrackNotFound
  | PingServer
  | GameUpdate GameInput
  | NoOp

