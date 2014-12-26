module Tut.State where

import Game (..)

type Step = Wind | FineTune | Vmg | Lock | Tack

type alias TutState =
  { playerState: PlayerState
  , step:        Step
  , stepTime:    Float
  }

defaultTutState : TutState
defaultTutState =
  { playerState = defaultPlayerState
  , step        = Wind
  , stepTime    = 0
  }