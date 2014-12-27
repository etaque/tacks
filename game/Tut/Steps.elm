module Tut.Steps where

import Tut.State (..)
import Tut.Inputs (..)

import Maybe as M
import Debug

serverStep : ServerUpdate -> TutState -> TutState
serverStep serverUpdate tutState =
  let
    { playerState, step, course } = serverUpdate
    typedStep = case step of
      "GateStep" -> GateStep
      "VmgSte"   -> VmgStep
      _          -> initialStep
    stepTime = if typedStep == tutState.step then tutState.stepTime else 0
    newCourse = M.withDefault tutState.course course
  in
    { tutState | playerState <- playerState,
                 step <- typedStep,
                 course <- newCourse,
                 stepTime <- stepTime }

timeStep : Float -> TutState -> TutState
timeStep delta tutState =
  let
    stepTime = tutState.stepTime + delta
  in
    { tutState | stepTime <- stepTime }

mainStep : TutInput -> TutState -> TutState
mainStep ({delta,keyboard,next,window,serverUpdate}) tutState =
  serverStep serverUpdate tutState
    |> timeStep delta
