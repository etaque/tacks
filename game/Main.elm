module Main where

import Window
import Signal exposing (..)
import Time exposing (..)
import Graphics.Element exposing (Element)

import Inputs exposing (..)
import Game exposing (AppState, initialAppState)
import Steps exposing (mainStep)
import Render.All exposing (renderApp)


port raceInput : Signal RaceInput

clock : Signal Clock
clock = map (\(time,delta) -> { time = time, delta = delta }) (timestamp (fps 30))

gameInput : Signal GameInput
gameInput = sampleOn clock <| map4 GameInput
  clock
  keyboardInput
  Window.dimensions
  raceInput

appInput : Signal AppInput
appInput = map AppInput gameInput

appState : Signal AppState
appState = foldp mainStep initialAppState appInput

-- port playerOutput : Signal PlayerOutput
-- port playerOutput =
--   map3 PlayerOutput
--     (.playerState >> Game.asOpponentState <~ gameState)
--     (.keyboardInput <~ gameInput)
--     (.localTime <~ gameState)

-- port title : Signal String
-- port title = Render.Utils.gameTitle <~ gameState

main : Signal Element
main = map2 renderApp Window.dimensions appState
