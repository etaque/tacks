module Main where

import Window
import Time exposing (timestamp, fps, every, second)
import Graphics.Element exposing (Element)
import Task exposing (Task)
import Http
import Json.Decode as Json

import Inputs exposing (..)
import Outputs exposing (..)
import State exposing (AppState, initialAppState)
import Steps exposing (mainStep)
import Render.All exposing (renderApp)
import Core exposing (isJust)
import Messages


-- Inputs

port liveCenterRunner : Signal (Task Http.Error ())
port liveCenterRunner =
  Signal.map (\_ -> runServerUpdate) (every second)

port raceInput : Signal (Maybe RaceInput)

port messagesStore : Json.Value


-- Signals

main : Signal Element
main =
  Signal.map2 (renderApp translator) Window.dimensions appState

translator : Messages.Translator
translator =
  Messages.translator (Messages.fromJson messagesStore)

clock : Signal Clock
clock =
  Signal.map (\(time,delta) -> { time = time, delta = delta }) (timestamp (fps 30))

gameInput : Signal (Maybe GameInput)
gameInput =
  Signal.map4 extractGameInput clock keyboardInput Window.dimensions raceInput
    |> Signal.sampleOn clock
    -- |> Signal.dropRepeats

appInput : Signal AppInput
appInput =
  Signal.map2 AppInput actionsMailbox.signal gameInput

appState : Signal AppState
appState =
  Signal.foldp mainStep initialAppState appInput


-- Outputs

port playerOutput : Signal (Maybe PlayerOutput)
port playerOutput =
  Signal.map2 extractPlayerOutput appState appInput
    |> Signal.dropRepeats

-- port title : Signal String
-- port title = Render.Utils.gameTitle <~ gameState

port activeRaceCourse : Signal (Maybe String)
port activeRaceCourse =
  Signal.map getActiveRaceCourse appState

