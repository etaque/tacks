module Page.Game.Model exposing (..)

import Time exposing (Time)
import Dict exposing (Dict)
import Model.Shared exposing (..)
import Game.Models exposing (GameState)
import Game.Inputs as Input
import Keyboard.Extra as Keyboard
import Window
import Set


type alias Model =
  { liveTrack : Maybe LiveTrack
  , gameState : Maybe GameState
  , raceInput : Input.RaceInput
  , keyboard : Keyboard.Model
  , dims : ( Int, Int )
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
  , raceInput = Input.initialRaceInput
  , keyboard = Keyboard.Model Set.empty
  , dims = ( 1 , 1 )
  , tab = LiveTab
  , races = []
  , freePlayers = []
  , live = False
  , messages = []
  , messageField = ""
  , ghostRuns = Dict.empty
  , notFound = False
  }


type Msg
  = Load (Result () LiveTrack) (Result () Course)
  | InitGameState LiveTrack Course Time
  | UpdateLiveTrack LiveTrack
  | KeyboardMsg Keyboard.Msg
  | WindowSize Window.Size
  | RaceUpdate Input.RaceInput
  | Frame Time
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
