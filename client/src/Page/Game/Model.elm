module Page.Game.Model (..) where

import Time exposing (Time)
import Dict exposing (Dict)
import Model.Shared exposing (..)
import Game.Models exposing (GameState)
import Game.Inputs exposing (GameInput)


type alias Model =
  { liveTrack : Maybe LiveTrack
  , gameState : Maybe GameState
  , tab : Tab
  , races : List Race
  , freePlayers : List Player
  , live : Bool
  , messages : List Message
  , messageField : String
  , ghostRuns : Dict String Player
  , notFound : Bool
  }


type Tab
  = LiveTab
  | RankingsTab
  | HelpTab


initial : Model
initial =
  { liveTrack = Nothing
  , gameState = Nothing
  , tab = LiveTab
  , races = []
  , freePlayers = []
  , live = False
  , messages = []
  , messageField = ""
  , ghostRuns = Dict.empty
  , notFound = False
  }


type Action
  = LoadLiveTrack (Result () LiveTrack)
  | InitGameState LiveTrack Time
  | UpdateLiveTrack LiveTrack
  | PingServer Time
  | GameUpdate GameInput
  | SetTab Tab
  | StartRace
  | ExitRace
  | EnterChat
  | LeaveChat
  | UpdateMessageField String
  | SubmitMessage
  | NewMessage Message
  | AddGhost String Player
  | RemoveGhost String
  | NoOp
