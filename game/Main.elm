module Main where

import Window

import Inputs (..)
import Game
import Steps
import Render.All as R
import Render.Utils

port raceInput : Signal
  { playerId:    String
  , now:         Float
  , startTime:   Maybe Float
  , course:      Maybe Game.Course
  , playerState: Maybe Game.PlayerState
  , wind:        Game.Wind
  , opponents:   [Game.PlayerState]
  , ghosts:      [Game.GhostState]
  , leaderboard: [Game.PlayerTally]
  , isMaster:    Bool
  , watching:    Bool
  , timeTrial:   Bool
  }

clock : Signal Float
clock = inSeconds <~ fps 30

input : Signal GameInput
input = sampleOn clock <| lift7 GameInput
  clock
  chrono
  keyboardInput
  mouseInput
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
main = lift2 R.renderAll Window.dimensions gameState
