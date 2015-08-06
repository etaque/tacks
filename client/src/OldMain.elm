module OldMain where

import Window
import Time exposing (timestamp, fps, every, second)
import Html exposing (Html)
import Task exposing (Task)
import Http
import Json.Decode as Json
import History

import Inputs exposing (..)
import Outputs exposing (..)
import State exposing (AppState, initialAppState)
import Game exposing (Player)
import Steps exposing (mainStep)
import Views.Main exposing (mainView)
import Core exposing (isJust)
import Messages
import Forms.Update as FormsUpdate exposing (submitMailbox)
import Routes exposing (pathChangeMailbox)


-- Inputs

port messagesStore : Json.Value

port currentPlayer : Player

port raceInput : Signal (Maybe RaceInput)


-- Tasks

port serverUpdateRunner : Signal (Task Http.Error ())
port serverUpdateRunner =
  Signal.map (\_ -> runServerUpdate) (every (5 * second))

port formSubmitsRunner : Signal (Task Http.Error ())
port formSubmitsRunner =
  Signal.map FormsUpdate.submitFormTask submitMailbox.signal

port pathChangeRunner : Signal (Task error ())
port pathChangeRunner =
  pathChangeMailbox.signal

port pathToScreenRunner : Signal (Task Http.Error ())
port pathToScreenRunner =
  Signal.map2 Routes.pathToScreenTask
    (Signal.sampleOn History.path appState)
    History.path


-- Signals

main : Signal Html
main =
  Signal.map2 (mainView translator) Window.dimensions appState

translator : Messages.Translator
translator =
  Messages.translator (Messages.fromJson messagesStore)

clock : Signal Clock
clock =
  Signal.map (\(time,delta) -> { time = time, delta = delta }) (timestamp (fps 30))

gameUpdate : Signal Action
gameUpdate =
  Signal.map4 extractGameUpdate clock keyboardInput Window.dimensions raceInput
    |> Signal.filterMap identity NoOp
    |> Signal.sampleOn clock
    |> Signal.dropRepeats

actions : Signal Action
actions =
  Signal.mergeMany
    [ actionsMailbox.signal
    , gameUpdate
    ]

appInput : Signal AppInput
appInput =
  Signal.map2 AppInput actions clock

appState : Signal AppState
appState =
  Signal.foldp mainStep (initialAppState currentPlayer) appInput


-- Outputs

port playerOutput : Signal (Maybe PlayerOutput)
port playerOutput =
  Signal.map2 extractPlayerOutput appState appInput
    |> Signal.filter isJust Nothing

-- port title : Signal String
-- port title = Render.Utils.gameTitle <~ gameState

port activeRaceCourse : Signal (Maybe String)
port activeRaceCourse =
  Signal.map getActiveRaceCourse appState
    |> Signal.dropRepeats

