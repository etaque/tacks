module Page.PlayLive.Model exposing (..)

import Time exposing (Time)
import Dict exposing (Dict)
import Model.Shared exposing (..)
import Game.Shared exposing (GameState, WithGame)
import Game.Touch as Touch exposing (Touch)
import Game.Msg exposing (GameMsg)
import Keyboard.Extra as Keyboard
import Set


type alias Model =
    WithGame
        { liveTrack : HttpData LiveTrack
        , tab : Tab
        , races : List Race
        , freePlayers : List Player
        }


type Tab
    = NoTab
    | LiveTab
    | RankingsTab
    | HelpTab


initial : Model
initial =
    { liveTrack = Loading
    , tab = NoTab
    , races = []
    , freePlayers = []
    , gameState = Nothing
    , lastPush = 0
    , keyboard = Keyboard.Model Set.empty
    , touch = Touch.initial
    , dims = ( 1, 1 )
    , live = False
    , ghostRuns = Dict.empty
    , chat = Game.Shared.initialChat
    }


type Msg
    = Load (HttpResult ( LiveTrack, Course ))
    | InitGameState LiveTrack Course Time
    | UpdateLiveTrack LiveTrack
    | SetTab Tab
    | GameMsg GameMsg
    | NoOp
