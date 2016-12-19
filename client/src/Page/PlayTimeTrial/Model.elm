module Page.PlayTimeTrial.Model exposing (..)

import Time exposing (Time)
import Dict exposing (Dict)
import Model.Shared exposing (..)
import Game.Shared exposing (GameState, WithGameControl)
import Game.Inputs as Input
import Game.Touch as Touch exposing (Touch)
import Keyboard.Extra as Keyboard
import Window
import Set


type alias Model =
    WithGameControl
        { gameState : Maybe GameState
        , lastPush : Time
        , keyboard : Keyboard.Model
        , touch : Touch
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
    { gameState = Nothing
    , lastPush = 0
    , keyboard = Keyboard.Model Set.empty
    , touch = Touch.initial
    , dims = ( 1, 1 )
    , tab = RankingsTab
    , live = False
    , ghostRuns = Dict.empty
    }


type Msg
    = LoadCourse (HttpResult Course)
    | InitGameState Course Time
    | KeyboardMsg Keyboard.Msg
    | TouchMsg Touch.Msg
    | WindowSize Window.Size
    | RaceUpdate Input.RaceInput
    | Frame Time
    | SetTab Tab
    | StartRace
    | ExitRace
    | AddGhost String Player
    | RemoveGhost String
    | NoOp
