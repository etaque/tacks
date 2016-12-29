module Page.PlayLive.Model exposing (..)

import Time exposing (Time)
import Dict exposing (Dict)
import Model.Shared exposing (..)
import Game.Shared exposing (GameState, WithGame)
import Game.Msg exposing (GameMsg)
import Dialog


type alias Model =
    WithGame
        { liveTrack : HttpData LiveTrack
        , showContext : Bool
        , dialog : Dialog.Model
        , dialogKind : Maybe DialogKind
        , races : List Race
        , freePlayers : List Player
        }


type DialogKind
    = ChooseControl
    | RankingsDialog
    | NewBestTime


initial : Model
initial =
    { liveTrack = Loading
    , showContext = False
    , dialog = Dialog.initial
    , dialogKind = Nothing
    , races = []
    , freePlayers = []
    , gameState = Nothing
    , lastPush = 0
    , direction = ( False, False )
    , dims = ( 1, 1 )
    , live = False
    , ghostRuns = Dict.empty
    , chat = Game.Shared.initialChat
    }


type Msg
    = Load (HttpResult ( LiveTrack, Course ))
    | InitGameState LiveTrack Course Time
    | UpdateLiveTrack LiveTrack
    | GameMsg GameMsg
    | ShowContext Bool
    | ShowDialog DialogKind
    | DialogMsg Dialog.Msg
    | NoOp
