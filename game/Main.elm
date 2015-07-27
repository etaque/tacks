module Main where

import Window
import Signal exposing (..)
import Time exposing (..)
import Graphics.Element exposing (Element)

import Inputs exposing (..)
import Game
import Steps
import Render.All as R
import Render.Utils

port raceInput : Signal RaceInput

port gameSetup : Game.GameSetup

clock : Signal Clock
clock = map (\(time,delta) -> { time = time, delta = delta }) (timestamp (fps 30))

input : Signal GameInput
input = sampleOn clock <| map4 GameInput
  clock
  --chrono
  keyboardInput
  Window.dimensions
  raceInput

initialState : Game.GameState
initialState = Game.defaultGame gameSetup

gameState : Signal Game.GameState
gameState = foldp Steps.stepGame initialState input

port playerOutput : Signal PlayerOutput
port playerOutput = map3 PlayerOutput
  (.playerState >> Game.asOpponentState <~ gameState)
  (.keyboardInput <~ input)
  (.localTime <~ gameState)

port title : Signal String
port title = Render.Utils.gameTitle <~ gameState

main : Signal Element
main = map2 R.render Window.dimensions gameState
