module SailGame where

import Window
import Keyboard

import Inputs
import Game
import Steps
import Render

{-- That's all folks! ---------------------------------------------------------

The following code puts it all together and shows it on screen.

------------------------------------------------------------------------------}

clock = timestamp (inSeconds <~ fps 30)
input = sampleOn clock (lift6 Inputs.Input clock Inputs.chrono Inputs.keyboardInput 
  Inputs.otherKeyboardInput Inputs.mouseInput Window.dimensions)

gameState = foldp Steps.stepGame Game.defaultGame input

main = lift2 Render.render Window.dimensions gameState

port log : Signal Int
port log = Keyboard.lastPressed


