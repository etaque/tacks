module Tut.Steps where

import Tut.State (..)
import Tut.Inputs (..)

mainStep : TutInput -> TutState -> TutState
mainStep input state =
  state