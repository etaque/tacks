module Main where

import Time exposing (timestamp, fps, every, second)
import Task exposing (Task, andThen)
import Html exposing (Html)
import Http
import Window
import History
import Signal.Extra exposing (foldp', passiveMap2)

import Models exposing (Player)
import AppUpdates exposing (..)
import AppTypes exposing (..)
import Game.Inputs exposing (RaceInput)
import Game.Outputs exposing (PlayerOutput)
import Screens.Game.Updates exposing (mapGameUpdate)
import AppView
import Routes


-- Inputs

port appSetup : AppSetup

port raceInput : Signal (Maybe RaceInput)


-- Signals

main : Signal Html
main =
  Signal.map2 AppView.view Window.dimensions appState

appState : Signal AppState
appState =
  Signal.map .appState appUpdates

appUpdates : Signal AppUpdate
appUpdates =
  let
    initialUpdate = (flip AppUpdates.update) (initialAppUpdate appSetup.player)
  in
    foldp' AppUpdates.update initialUpdate appInputs

appInputs : Signal AppInput
appInputs =
  passiveMap2 AppInput allActions clock

allActions : Signal AppAction
allActions =
  Signal.mergeMany
    [ Signal.constant (SetPath appSetup.path)
    , screenActions
    , actionsMailbox.signal
    , pathActions
    , gameActions
    ]

gameActions : Signal AppAction
gameActions =
  Signal.map3 mapGameUpdate Game.Inputs.keyboardInput Window.dimensions raceInput
    |> Signal.filterMap (Maybe.map GameAction) NoOp
    |> Signal.sampleOn clock
    |> Signal.dropRepeats

pathActions : Signal AppAction
pathActions =
  Signal.map SetPath History.path

reactions : Signal (Task Http.Error ())
reactions =
  Signal.map .reaction appUpdates
    |> Signal.filterMap identity (Task.succeed ())

requests : Signal (Task error AppAction)
requests =
  Signal.map .request appUpdates
    |> Signal.filterMap identity NoOp
    |> Signal.map Task.succeed

clock : Signal Clock
clock =
  Signal.map (\(time,delta) -> { time = time, delta = delta }) (timestamp (fps 30))


-- Runners

port reactionsRunner : Signal (Task Http.Error Task.ThreadID)
port reactionsRunner =
  Signal.map Task.spawn reactions

port requestsRunner : Signal (Task error Task.ThreadID)
port requestsRunner =
  Signal.map (\t -> Task.spawn (t `andThen` (Signal.send actionsMailbox.address))) requests

port pathChangeRunner : Signal (Task error ())
port pathChangeRunner =
  .signal Routes.pathChangeMailbox


-- Outputs

port playerOutput : Signal (Maybe PlayerOutput)
port playerOutput =
  Signal.map2 Game.Outputs.extractPlayerOutput appState gameActions
    |> Signal.dropRepeats

-- port title : Signal String
-- port title = Render.Utils.gameTitle <~ gameState

port activeTrack : Signal (Maybe String)
port activeTrack =
  Signal.map Game.Outputs.getActiveTrack appState
    |> Signal.dropRepeats
