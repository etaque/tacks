module Main where

import Window
import Signal (..)
import Time (..)
import Graphics.Element (Element)

import Inputs (..)
import Game
import Steps
import Render.All as R
import Render.Utils

port raceInput : Signal RaceInput

clock : Signal Float
clock = inSeconds <~ fps 30

input : Signal GameInput
input = sampleOn clock <| map5 GameInput
  clock
  --chrono
  keyboardInput
  Window.dimensions
  raceInput
  watcherInput

gameState : Signal Game.GameState
gameState = foldp Steps.stepGame Game.defaultGame input

port playerOutput : Signal KeyboardInput
port playerOutput = .keyboardInput <~ input

port watcherOutput : Signal WatcherInput
port watcherOutput = .watcherInput <~ input

port title : Signal String
port title = Render.Utils.gameTitle <~ gameState

main : Signal Element
main = map2 R.renderAll Window.dimensions gameState
