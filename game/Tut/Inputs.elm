module Tut.Inputs where

import Inputs (..)
import Game

import Keyboard
import Char


nextStepInput : Signal Bool
nextStepInput = (Keyboard.isDown (Char.toCode 'N'))

type alias ServerUpdate =
  { playerState: Game.PlayerState
  , course:      Maybe Game.Course
  , step:        String
  }

type alias TutInput =
  { delta:        Float
  , keyboard:     KeyboardInput
  , next:         Bool
  , window:       (Int,Int)
  , serverUpdate: ServerUpdate
  }
