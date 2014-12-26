module Tut.Steps where

import Tut.State (..)
import Tut.Inputs (..)

mainStep : TutInput -> TutState -> TutState
mainStep ({delta,keyboard,next,window}) state =
  let
    stepTime = state.stepTime + delta
  in
    { state | stepTime <- stepTime }
