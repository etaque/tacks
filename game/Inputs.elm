module Inputs where

import Game

import Keyboard
import Mouse
import Drag
import Time
import Char
import Graphics.Input(Input,input)

type UserArrows = { x:Int, y:Int }

type KeyboardInput =
  { arrows:         UserArrows
  , lock:           Bool
  , tack:           Bool
  , subtleTurn:     Bool
  , startCountdown: Bool
  }

type MouseInput = { drag: Maybe (Int,Int), mouse: (Int,Int) }

type RaceInput =
  { playerId:    String
  , now:         Time
  , startTime:   Maybe Time
  , course:      Maybe Game.Course
  , playerState: Maybe Game.PlayerState
  , wind:        Game.Wind
  , opponents:   [Game.PlayerState]
  , leaderboard: [Game.PlayerTally]
  , isMaster:    Bool
  , watching:    Bool
  }

mouseInput : Signal MouseInput
mouseInput = lift2 MouseInput (Drag.lastPosition (20 * Time.millisecond)) Mouse.position

keyboardInput : Signal KeyboardInput
keyboardInput = lift5 KeyboardInput
  Keyboard.arrows
  Keyboard.enter
  Keyboard.space
  Keyboard.shift
  (Keyboard.isDown (Char.toCode 'C'))

chrono : Signal Time
chrono = foldp (+) 0 (fps 1)

watchedPlayer : Input (Maybe String)
watchedPlayer = input Nothing

type WatcherInput =
  { watchedPlayerId: Maybe String }

watcherInput : Signal WatcherInput
watcherInput = WatcherInput <~ watchedPlayer.signal

type GameInput =
  { delta:         Float
  , chrono:        Time
  , keyboardInput: KeyboardInput
  , mouseInput:    MouseInput
  , windowInput:   (Int,Int)
  , raceInput:     RaceInput
  , watcherInput:  WatcherInput
  }

