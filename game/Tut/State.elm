module Tut.State where

import Game (..)

type Step = Wind | FineTune | Vmg | Lock | Tack

type alias TutState =
  { playerState: PlayerState
  , step:        Step
  }

defaultTutState : TutState
defaultTutState =
  { playerState = defaultPlayerState
  , step        = Wind
  }