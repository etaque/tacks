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

type alias RaceInput =
  { playerId:    String
  , now:         Time
  , startTime:   Maybe Time
  , course:      Maybe Game.Course
  , playerState: Maybe Game.PlayerState
  , wind:        Game.Wind
  , opponents:   List Game.PlayerState
  , ghosts:      List Game.GhostState
  , leaderboard: List Game.PlayerTally
  , isMaster:    Bool
  , watching:    Bool
  , timeTrial:   Bool
  }

keyboardInput : Signal KeyboardInput
keyboardInput = map5 KeyboardInput
  Keyboard.arrows
  Keyboard.enter
  Keyboard.space
  Keyboard.shift
  (Keyboard.isDown (Char.toCode 'C'))

watchedPlayer : Channel (Maybe String)
watchedPlayer = channel Nothing

type alias WatcherInput =
  { watchedPlayerId: Maybe String }

watcherInput : Signal WatcherInput
watcherInput = WatcherInput <~ (subscribe watchedPlayer)

type alias GameInput =
  { delta:         Float
  , keyboardInput: KeyboardInput
  , windowInput:   (Int,Int)
  , raceInput:     RaceInput
  , watcherInput:  WatcherInput
  }
