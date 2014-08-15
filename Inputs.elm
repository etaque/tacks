module Inputs where

import Keyboard
import Mouse
import Drag
import Time

{-- Part 1: Model the user input ----------------------------------------------

What information do you need to represent all relevant user input?

Task: Redefine `UserInput` to include all of the information you need.
      Redefine `userInput` to be a signal that correctly models the user
      input as described by `UserInput`.

------------------------------------------------------------------------------}

type UserArrows = { x:Int, y:Int }
type KeyboardInput = { arrows: UserArrows, lockAngle: Bool, tack: Bool }
type MouseInput = { drag: Maybe (Int,Int), mouse: (Int,Int) }
type GameClock = (Time, Float)

mouseInput : Signal MouseInput
mouseInput = lift2 MouseInput (Drag.lastPosition (20 * Time.millisecond)) Mouse.position

keyboardInput : Signal KeyboardInput
keyboardInput = lift3 KeyboardInput Keyboard.arrows Keyboard.enter Keyboard.space

otherKeyboardInput : Signal KeyboardInput
otherKeyboardInput = lift3 KeyboardInput (Keyboard.directions 90 83 81 68) Keyboard.shift Keyboard.ctrl

type Input = { clock: GameClock, keyboardInput: KeyboardInput, otherKeyboardInput: KeyboardInput, 
               mouseInput: MouseInput, windowInput: (Int,Int) }
