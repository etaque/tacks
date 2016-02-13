module Page.Game.Model where

import Time exposing (Time)

import Model.Shared exposing (..)
import Game.Models exposing (GameState)
import Game.Inputs exposing (GameInput)

type alias Model =
  { liveTrack : Maybe LiveTrack
  , gameState : Maybe GameState
  , races : List Race
  , freePlayers : List Player
  , live : Bool
  , messages : List Message
  , messageField : String
  , notFound : Bool
  }

initial : Model
initial =
  { liveTrack = Nothing
  , gameState = Nothing
  , races = []
  , freePlayers = []
  , live = False
  , messages = []
  , messageField = ""
  , notFound = False
  }

type Action
  = LoadLiveTrack (Result () LiveTrack)
  | InitGameState LiveTrack Time
  | UpdateLiveTrack LiveTrack
  | PingServer Time
  | GameUpdate GameInput
  | EnterChat
  | LeaveChat
  | UpdateMessageField String
  | SubmitMessage
  | NewMessage Message
  | NoOp
