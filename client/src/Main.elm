module Main where

import Time exposing (timestamp, fps, every, second)
import Task exposing (Task, andThen)
import Html exposing (Html)
import Window
import History
import Json.Decode as Json
import Signal.Extra exposing (foldp', passiveMap2)

import AppUpdates exposing (..)
import AppTypes exposing (..)
import Game.Inputs exposing (RaceInput)
import Game.Outputs exposing (PlayerOutput)
import Game.Outputs exposing (PlayerOutput)
import Screens.Game.Updates exposing (mapGameUpdate,chat)
import Screens.EditTrack.Updates as EditTrack
import Screens.Game.Decoders as GameDecoders
import AppView
import Routes


-- Inputs

port appSetup : AppSetup

port initialDims : (Int, Int)

port raceInput : Signal (Maybe RaceInput)

port gameActionsInput : Signal Json.Value


-- Signals

main : Signal Html
main =
  Signal.map AppView.view appState

appState : Signal AppState
appState =
  Signal.map .appState appUpdates

appUpdates : Signal AppUpdate
appUpdates =
  let
    initialUpdate = (flip AppUpdates.update) (initialAppUpdate initialDims appSetup.player)
  in
    foldp' AppUpdates.update initialUpdate appInputs

appInputs : Signal AppInput
appInputs =
  passiveMap2 AppInput allActions clock

allActions : Signal AppAction
allActions =
  Signal.mergeMany
    [ initPathAction
    , pathActions
    , dimsActions
    , appActionsMailbox.signal
    , raceUpdateActions
    , gameActions
    , editorInputActions
    ]

initPathAction : Signal AppAction
initPathAction =
  Signal.constant (SetPath appSetup.path)

pathActions : Signal AppAction
pathActions =
  Signal.map SetPath History.path

dimsActions : Signal AppAction
dimsActions =
  Signal.map UpdateDims Window.dimensions

raceUpdateActions : Signal AppAction
raceUpdateActions =
  Signal.map3 mapGameUpdate Game.Inputs.keyboardInput Window.dimensions raceInput
    |> Signal.filterMap (Maybe.map (GameAction >> ScreenAction)) AppTypes.AppNoOp
    |> Signal.sampleOn clock
    |> Signal.dropRepeats

gameActions : Signal AppAction
gameActions =
  Signal.map (GameDecoders.decodeAction >> GameAction >> ScreenAction) gameActionsInput

editorInputActions : Signal AppAction
editorInputActions =
  Signal.map (EditTrackAction >> ScreenAction) EditTrack.inputs

reactions : Signal (Task Never ())
reactions =
  Signal.map .reaction appUpdates
    |> Signal.filterMap identity (Task.succeed ())

requests : Signal (Task error AppAction)
requests =
  Signal.map .request appUpdates
    |> Signal.filterMap identity AppTypes.AppNoOp
    |> Signal.map Task.succeed

clock : Signal Clock
clock =
  Signal.map (\(time,delta) -> { time = time, delta = delta }) (timestamp (fps 30))


-- Runners

port reactionsRunner : Signal (Task error Task.ThreadID)
port reactionsRunner =
  Signal.map Task.spawn reactions

port requestsRunner : Signal (Task error Task.ThreadID)
port requestsRunner =
  Signal.map (\t -> Task.spawn (t `andThen` (Signal.send appActionsMailbox.address))) requests

port pathChangeRunner : Signal (Task error ())
port pathChangeRunner =
  .signal Routes.pathChangeMailbox


-- Outputs

port playerOutput : Signal (Maybe PlayerOutput)
port playerOutput =
  Signal.map2 Game.Outputs.extractPlayerOutput appState raceUpdateActions
    |> Signal.dropRepeats

-- port title : Signal String
-- port title = Render.Utils.gameTitle <~ gameState

port activeTrack : Signal (Maybe String)
port activeTrack =
  Signal.map Game.Outputs.getActiveTrack appState
    |> Signal.dropRepeats

port chatOutput : Signal String
port chatOutput =
  chat.signal

port chatScrollDown : Signal ()
port chatScrollDown =
  Signal.filterMap Game.Outputs.needChatScrollDown () gameActions
