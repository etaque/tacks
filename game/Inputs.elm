module Inputs where

import Game

import Signal (..)
import Time (..)
import Keyboard
import Char
import Graphics.Input

type alias UserArrows = { x: Int, y: Int }

type alias KeyboardInput =
  { arrows:         UserArrows
  , lock:           Bool
  , tack:           Bool
  , subtleTurn:     Bool
  , startCountdown: Bool
  }

manualTurn ki = ki.arrows.x /= 0
isTurning ki = manualTurn ki && not ki.subtleTurn
isSubtleTurning ki = manualTurn ki && ki.subtleTurn
isLocking ki = ki.arrows.y > 0 || ki.lock

keyboardInput : Signal KeyboardInput
keyboardInput = map5 KeyboardInput
  Keyboard.arrows
  Keyboard.enter
  Keyboard.space
  Keyboard.shift
  (Keyboard.isDown (Char.toCode 'C'))


type alias RaceInput =
  { serverNow:   Time
  , startTime:   Maybe Time
  , wind:        Game.Wind
  , opponents:   List Game.Opponent
  , ghosts:      List Game.GhostState
  , leaderboard: List Game.PlayerTally
  , isMaster:    Bool
  , initial:     Bool
  , clientTime:  Time
  }

type alias Clock =
  { delta: Float
  , time: Float
  }

type alias GameInput =
  { clock:         Clock
  , keyboardInput: KeyboardInput
  , windowInput:   (Int,Int)
  , raceInput:     RaceInput
  }

type alias PlayerOutput =
  { state: Game.OpponentState
  , input: KeyboardInput
  , localTime: Float
  }