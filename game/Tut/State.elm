module Tut.State where

import Game (..)

type Step = TurningStep | GateStep | VmgStep

type alias TutState =
  { playerState: PlayerState
  , step:        Step
  , stepTime:    Float
  , course:      Course
}

initialStep : Step
initialStep = TurningStep

defaultTutState : TutState
defaultTutState =
  { playerState = defaultPlayerState
  , step        = initialStep
  , stepTime    = 0
  , course      = defaultCourse
  }