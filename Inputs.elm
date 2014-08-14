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
type KeyboardInput = { arrows: UserArrows, shift: Bool, space: Bool, aKey: Bool, dKey: Bool }
type MouseInput = { drag: Maybe (Int,Int), mouse: (Int,Int) }
type GameClock = (Time, Float)

mouseInput : Signal MouseInput
mouseInput = lift2 MouseInput (Drag.lastPosition (20 * Time.millisecond)) Mouse.position

keyboardInput : Signal KeyboardInput
keyboardInput = lift5 KeyboardInput 
  Keyboard.arrows Keyboard.shift Keyboard.space (Keyboard.isDown 65) (Keyboard.isDown 68)

type Input = { clock: GameClock, keyboardInput: KeyboardInput, mouseInput: MouseInput }
