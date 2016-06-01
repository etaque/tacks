module Page.Game.Model exposing (..)

import Time exposing (Time)
import Dict exposing (Dict)
import Model.Shared exposing (..)
import Game.Models exposing (GameState)
import Game.Inputs as Input
import Keyboard.Extra as Keyboard
import Page.Game.Chat.Model as Chat
import Window
import Set


type alias Model =
  { liveTrack : Maybe LiveTrack
  , gameState : Maybe GameState
  , lastPush : Time
  , keyboard : Keyboard.Model
  , dims : ( Int, Int )
  , tab : Tab
  , races : List Race
  , freePlayers : List Player
  , live : Bool
  , ghostRuns : Dict String Player
  , chat : Chat.Model
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
  , lastPush = 0
  , keyboard = Keyboard.Model Set.empty
  , dims = ( 1 , 1 )
  , tab = LiveTab
  , races = []
  , freePlayers = []
  , live = False
  , ghostRuns = Dict.empty
  , chat = Chat.initial
  , notFound = False
  }


type Msg
  = Load (Result () LiveTrack) (Result () Course)
  | InitGameState LiveTrack Course Time
  | UpdateLiveTrack LiveTrack
  | KeyboardMsg Keyboard.Msg
  | ChatMsg Chat.Msg
  | WindowSize Window.Size
  | RaceUpdate Input.RaceInput
  | Frame Time
  | SetTab Tab
  | StartRace
  | ExitRace
  | AddGhost String Player
  | RemoveGhost String
  | NoOp


