module Main where

import Time exposing (timestamp, fps, every, second)
import Signal exposing (map)
import Task exposing (Task, andThen)
import Html exposing (Html)
import Window
import Json.Decode as Json
import Effects exposing (Effects, Never)
import StartApp
import Drag exposing (mouseEvents)
import TransitRouter

import Update
import Model exposing (..)
import Game.Inputs as GameInputs
import Game.Outputs as GameOutputs
import Page.Game.Update exposing (chat)
import Page.Game.Model as GameModel
import Page.EditTrack.Update as EditTrack
import Page.Game.Decoders as GameDecoders
import View


-- Inputs

port appSetup : AppSetup

port raceInput : Signal (Maybe GameInputs.RaceInput)

port gameActionsInput : Signal Json.Value


-- Wiring

app : StartApp.App Model
app = StartApp.start
  { init = Update.init appSetup
  , update = Update.update
  , view = View.view
  , inputs =
    [ map RouterAction TransitRouter.actions
    , map UpdateDims Window.dimensions
    , map MouseEvent mouseEvents
    , appActionsMailbox.signal
    , raceUpdateActions
    , gameActions
    , map (EditTrackAction >> PageAction) EditTrack.inputs
    ]
  }

main : Signal Html
main = app.html

port tasks : Signal (Task.Task Never ())
port tasks = app.tasks


-- Complex signals

rawInput : Signal (GameInputs.KeyboardInput, (Int, Int), Maybe GameInputs.RaceInput)
rawInput =
  Signal.map3 (,,) GameInputs.keyboardInput Window.dimensions raceInput

raceUpdateActions : Signal Action
raceUpdateActions =
  Signal.map2 GameInputs.buildGameInput rawInput clock
    |> Signal.filterMap (Maybe.map (GameModel.GameUpdate >> GameAction >> PageAction)) Model.NoOp
    |> Signal.sampleOn clock
    |> Signal.dropRepeats

gameActions : Signal Action
gameActions =
  Signal.map (GameDecoders.decodeAction >> GameAction >> PageAction) gameActionsInput

clock : Signal GameInputs.Clock
clock =
  Signal.map (\ (time,delta) -> { time = time, delta = delta }) (timestamp (fps 30))


-- Outputs

port playerOutput : Signal (Maybe GameOutputs.PlayerOutput)
port playerOutput =
  Signal.map2 GameOutputs.extractPlayerOutput app.model raceUpdateActions
    |> Signal.dropRepeats

port activeTrack : Signal (Maybe String)
port activeTrack =
  Signal.map GameOutputs.getActiveTrack app.model
    |> Signal.dropRepeats

port chatOutput : Signal String
port chatOutput =
  chat.signal

port chatScrollDown : Signal ()
port chatScrollDown =
  Signal.filterMap GameOutputs.needChatScrollDown () gameActions
