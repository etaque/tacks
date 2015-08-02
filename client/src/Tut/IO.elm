module Tut.IO where

import Inputs (..)
import Game
import Messages (Messages)
import Tut.State (..)

import Keyboard
import Char


nextStepInput : Signal Bool
nextStepInput = (Keyboard.isDown (Char.toCode 'N'))

type alias ServerUpdate =
  { playerState: Game.PlayerState
  , course:      Maybe Game.Course
  , step:        String
  , messages:    Maybe (List (String,String))
  }

type alias TutInput =
  { delta:        Float
  , keyboard:     KeyboardInput
  , next:         Bool
  , window:       (Int,Int)
  , serverUpdate: ServerUpdate
  }

type alias TutOutput =
  { keyboard: KeyboardInput
  , step:     String
  , window:   (Int,Int)
  }