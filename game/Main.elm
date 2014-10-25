module Main where

import Window

import Inputs (..)
import Game
import Steps
import Render.All as R
import Render.Utils

import Debug

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

input : Signal GameInput
input = sampleOn clock <| lift6 GameInput
  clock
  chrono
  keyboardInput
  mouseInput
  Window.dimensions
  raceInput

gameState : Signal Game.GameState
gameState = foldp Steps.stepGame Game.defaultGame input

port playerOutput : Signal KeyboardInput
port playerOutput = .keyboardInput <~ input

port watcherOutput : Signal WatcherOutput
port watcherOutput = WatcherOutput <~ watchedPlayer.signal

port title : Signal String
port title = Render.Utils.gameTitle <~ gameState

main : Signal Element
main = lift2 R.renderAll Window.dimensions gameState
