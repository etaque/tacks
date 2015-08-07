module Tut.State where

import Game (..)
import Messages (..)
import Game.Core as Core (find)

import Maybe as M
import List (..)


type Step
  = InitialStep
  | CourseStep
  | TurningStep
  | TheoryStep
  | GateStep
  | LapStep
  | VmgStep
  | FinalStep

orderedSteps : List Step
orderedSteps =
  [ InitialStep
  , CourseStep
  --, TurningStep
  , TheoryStep
  , GateStep
  , LapStep
  , VmgStep
  , FinalStep
  ]

stepTransitions : List (Step,Step)
stepTransitions = map2 (,) orderedSteps (tail orderedSteps)

nextStep : Step -> Step
nextStep s =
  find (\t -> fst t == s) stepTransitions
    |> M.map snd
    |> M.withDefault FinalStep


stepFromString : String -> Step
stepFromString s =
  find (\s' -> (toString s' == s)) orderedSteps |> M.withDefault InitialStep


type alias TutState =
  { playerState: PlayerState
  , step:        Step
  , stepTime:    Float
  , course:      Course
  , messages:    Messages
}

defaultTutState : TutState
defaultTutState =
  { playerState = defaultPlayerState
  , step        = InitialStep
  , stepTime    = 0
  , course      = defaultCourse
  , messages    = emptyMessages
  }
