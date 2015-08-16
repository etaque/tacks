module Screens.Game.Types where

import Models exposing (..)
import Game.Models exposing (GameState)
import Game.Inputs exposing (GameInput)

type alias Screen =
  { liveTrack : Maybe LiveTrack
  , gameState : Maybe GameState
  , races : List Race
  , freePlayers : List Player
  , live : Bool
  , messages : List Message
  , messageField : String
  , notFound : Bool
  }

type Action
  = SetLiveTrack LiveTrack
  | UpdateLiveTrack LiveTrack
  | TrackNotFound
  | PingServer
  | GameUpdate GameInput
  | EnterChat
  | LeaveChat
  | UpdateMessageField String
  | SubmitMessage
  | NewMessage Message
  | NoOp

