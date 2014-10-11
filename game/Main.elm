module Main where

import Window

import Inputs
import Game
import Steps
import Render.All as R
import Render.Utils

port raceInput : Signal
  { now: Float
  , startTime: Maybe Float
  , course: Maybe Game.Course
  , playerState: Maybe Game.PlayerState
  , wind: Game.Wind
  , opponents: [Game.PlayerState]
  , leaderboard: [Game.PlayerTally]
  , isMaster: Bool
  }

clock : Signal Float
clock = inSeconds <~ fps 30

input : Signal Inputs.Input
input = sampleOn clock (lift6 Inputs.Input
  clock Inputs.chrono Inputs.keyboardInput Inputs.mouseInput Window.dimensions raceInput)

gameState : Signal Game.GameState
gameState = foldp Steps.stepGame Game.defaultGame input

port playerOutput : Signal Inputs.KeyboardInput
port playerOutput = .keyboardInput <~ input

port title : Signal String
port title = Render.Utils.gameTitle <~ gameState

main : Signal Element
main = lift2 R.renderAll Window.dimensions gameState
