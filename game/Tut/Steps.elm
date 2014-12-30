module Tut.Steps where

import Tut.State (..)
import Tut.IO (..)
import Messages
import Game (Course)

import Maybe as M

serverStep : ServerUpdate -> TutState -> TutState
serverStep serverUpdate tutState =
  let
    { playerState, step, course, messages } = serverUpdate
    newCourse = M.withDefault tutState.course course
    newMessages = M.map Messages.fromList messages |> M.withDefault tutState.messages
  in
    { tutState |
      playerState <- playerState,
      course      <- newCourse,
      messages    <- newMessages
    }

stepStep : Bool -> TutState -> TutState
stepStep next tutState =
  if next && tutState.stepTime > 300
    then { tutState | step <- (nextStep tutState.step), stepTime <- 0 }
    else tutState

timeStep : Float -> TutState -> TutState
timeStep delta tutState =
  let
    stepTime = tutState.stepTime + delta
  in
    { tutState | stepTime <- stepTime }

mainStep : TutInput -> TutState -> TutState
mainStep ({delta,keyboard,next,window,serverUpdate}) tutState =
  serverStep serverUpdate tutState
    |> stepStep next
    |> timeStep delta
