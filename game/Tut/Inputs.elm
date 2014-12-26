module Tut.Inputs where

import Inputs (..)

type alias TutInput =
  { delta:         Float
  , keyboardInput: KeyboardInput
  , windowInput:   (Int,Int)
  }
