module Inputs where

import Game

import Signal exposing (..)
import Time exposing (..)
import List as L
import Set as S exposing (..)
import Keyboard
import Char
import Graphics.Input

type alias AppInput =
  { gameInput : GameInput }

type alias GameInput =
  { clock : Clock
  , keyboardInput : KeyboardInput
  , windowInput : (Int,Int)
  , raceInput : RaceInput
  }

type alias Clock =
  { delta : Float
  , time : Float
  }

type alias KeyboardInput =
  { arrows : UserArrows
  , lock : Bool
  , tack : Bool
  , subtleTurn : Bool
  , startCountdown : Bool
  , escapeRun : Bool
  }

type alias UserArrows = { x : Int, y : Int }

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

manualTurn ki = ki.arrows.x /= 0
isTurning ki = manualTurn ki && not ki.subtleTurn
isSubtleTurning ki = manualTurn ki && ki.subtleTurn
isLocking ki = ki.arrows.y > 0 || ki.lock

toKeyboardInput : UserArrows -> Set Keyboard.KeyCode -> KeyboardInput
toKeyboardInput arrows keys =
  { arrows = arrows
  , lock = S.member 13 keys
  , tack = S.member 32 keys
  , subtleTurn = S.member 16 keys
  , startCountdown = S.member (Char.toCode 'C') keys
  , escapeRun = S.member 27 keys
  }

keyboardInput : Signal KeyboardInput
keyboardInput = Signal.map2 toKeyboardInput
  Keyboard.arrows
  Keyboard.keysDown

type alias PlayerOutput =
  { state: Game.OpponentState
  , input: KeyboardInput
  , localTime: Float
  }
