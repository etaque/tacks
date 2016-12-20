module Page.PlayTimeTrial.Model exposing (..)

import Time exposing (Time)
import Dict exposing (Dict)
import Model.Shared exposing (..)
import Game.Shared exposing (GameState, WithGame)
import Game.Msg exposing (GameMsg)
import Game.Touch as Touch exposing (Touch)
import Keyboard.Extra as Keyboard
import Set


type alias Model =
    WithGame
        { tab : Tab
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
    , chat = Game.Shared.initialChat
    }


type Msg
    = LoadCourse (HttpResult Course)
    | InitGameState Course Time
    | SetTab Tab
    | GameMsg GameMsg
    | NoOp
