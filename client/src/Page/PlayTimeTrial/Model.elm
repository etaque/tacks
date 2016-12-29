module Page.PlayTimeTrial.Model exposing (..)

import Time exposing (Time)
import Dict exposing (Dict)
import Model.Shared exposing (..)
import Game.Shared exposing (GameState, WithGame)
import Game.Msg exposing (GameMsg)
import Dialog


type alias Model =
    WithGame
        { showContext : Bool
        , dialog : Dialog.Model
        , dialogKind : Maybe DialogKind
        }


type DialogKind
    = ChooseControl
    | RankingsDialog
    | NewBestTime


initial : Model
initial =
    { showContext = False
    , dialog = Dialog.initial
    , dialogKind = Nothing
    , gameState = Nothing
    , lastPush = 0
    , direction = ( False, False )
    , dims = ( 1, 1 )
    , live = False
    , ghostRuns = Dict.empty
    , chat = Game.Shared.initialChat
    }


type Msg
    = LoadCourse (HttpResult Course)
    | InitGameState Course Time
    | GameMsg GameMsg
    | ShowContext Bool
    | ShowDialog DialogKind
    | DialogMsg Dialog.Msg
    | NoOp
