module Page.PlayTimeTrial.Model exposing (..)

import Time exposing (Time)
import Dict exposing (Dict)
import Model.Shared exposing (..)
import Game.Models exposing (GameState)
import Game.Inputs as Input
import Keyboard.Extra as Keyboard
import Window
import Set


type alias Model =
    { liveTimeTrial : HttpData LiveTimeTrial
    , gameState : Maybe GameState
    , lastPush : Time
    , keyboard : Keyboard.Model
    , dims : ( Int, Int )
    , tab : Tab
    , live : Bool
    , ghostRuns : Dict String Player
    }


type Tab
    = RankingsTab
    | HelpTab


initial : Model
initial =
    { liveTimeTrial = Loading
    , gameState = Nothing
    , lastPush = 0
    , keyboard = Keyboard.Model Set.empty
    , dims = ( 1, 1 )
    , tab = RankingsTab
    , live = False
    , ghostRuns = Dict.empty
    }


type Msg
    = Load (HttpResult ( LiveTimeTrial, Course ))
    | InitGameState Course Time
      -- | UpdateLiveTrack LiveTimeTrial
    | KeyboardMsg Keyboard.Msg
    | WindowSize Window.Size
    | RaceUpdate Input.RaceInput
    | Frame Time
    | SetTab Tab
    | StartRace
    | ExitRace
    | AddGhost String Player
    | RemoveGhost String
    | NoOp
