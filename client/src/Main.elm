module Main where

import Time exposing (timestamp, fps, every, second)
import Task exposing (Task, andThen)
import Html exposing (Html)
import Window
import History
import Json.Decode as Json
import Effects exposing (Effects, Never)
import StartApp
import DragAndDrop exposing (mouseEvents)

import AppUpdates
import AppTypes exposing (..)
import Game.Inputs exposing (..)
import Game.Outputs exposing (PlayerOutput)
import Game.Outputs exposing (PlayerOutput)
import Screens.Game.Updates exposing (chat)
import Screens.Game.Types as GameTypes
import Screens.EditTrack.Updates as EditTrack
import Screens.Game.Decoders as GameDecoders
import AppView


-- Inputs

port appSetup : AppSetup

port raceInput : Signal (Maybe RaceInput)

port gameActionsInput : Signal Json.Value


-- Wiring

app : StartApp.App AppState
app = StartApp.start
  { init = AppUpdates.initialAppUpdate appSetup
  , update = AppUpdates.update
  , view = AppView.view
  , inputs =
    [ pathActions
    , dimsActions
    , mouseEventActions
    , appActionsMailbox.signal
    , raceUpdateActions
    , gameActions
    , editorInputActions
    ]
  }

main : Signal Html
main = app.html

port tasks : Signal (Task.Task Never ())
port tasks = app.tasks

initPathAction : Signal AppAction
initPathAction =
  Signal.constant (PathChanged appSetup.path)

pathActions : Signal AppAction
pathActions =
  Signal.map PathChanged History.path

dimsActions : Signal AppAction
dimsActions =
  Signal.map UpdateDims Window.dimensions

mouseEventActions : Signal AppAction
mouseEventActions =
  Signal.map MouseEvent mouseEvents

rawInput : Signal (KeyboardInput, (Int, Int), Maybe RaceInput)
rawInput =
  Signal.map3 (,,) Game.Inputs.keyboardInput Window.dimensions raceInput

raceUpdateActions : Signal AppAction
raceUpdateActions =
  Signal.sampleOn rawInput clock
    |> Signal.map2 buildGameInput rawInput
    |> Signal.filterMap (Maybe.map (GameTypes.GameUpdate >> GameAction >> ScreenAction)) AppTypes.AppNoOp
    |> Signal.sampleOn clock
    |> Signal.dropRepeats

gameActions : Signal AppAction
gameActions =
  Signal.map (GameDecoders.decodeAction >> GameAction >> ScreenAction) gameActionsInput

editorInputActions : Signal AppAction
editorInputActions =
  Signal.map (EditTrackAction >> ScreenAction) EditTrack.inputs

clock : Signal Clock
clock =
  Signal.map (\(time,delta) -> { time = time, delta = delta }) (timestamp (fps 30))


-- Outputs

port playerOutput : Signal (Maybe PlayerOutput)
port playerOutput =
  Signal.map2 Game.Outputs.extractPlayerOutput app.model raceUpdateActions
    |> Signal.dropRepeats

port activeTrack : Signal (Maybe String)
port activeTrack =
  Signal.map Game.Outputs.getActiveTrack app.model
    |> Signal.dropRepeats

port chatOutput : Signal String
port chatOutput =
  chat.signal

port chatScrollDown : Signal ()
port chatScrollDown =
  Signal.filterMap Game.Outputs.needChatScrollDown () gameActions
