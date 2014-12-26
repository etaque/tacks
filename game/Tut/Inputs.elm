module Tut.Inputs where

import Inputs (..)
import Keyboard
import Char

nextStepInput : Signal Bool
nextStepInput = (Keyboard.isDown (Char.toCode 'N'))


type alias TutInput =
  { delta:    Float
  , keyboard: KeyboardInput
  , next:     Bool
  , window:   (Int,Int)
  }
