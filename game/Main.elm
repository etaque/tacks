module ShiftMaster where

import Window
import Keyboard
import WebSocket
import Json

import Inputs
import Game
import Steps
import Render

{-- That's all folks! ---------------------------------------------------------

The following code puts it all together and shows it on screen.

------------------------------------------------------------------------------}

port raceInput : Signal { now: Float, startTime: Float, opponents: [{ position : { x: Float, y: Float}, 
                          direction: Float, velocity: Float, passedGates: [Float] }]}

clock : Signal Float
clock = inSeconds <~ fps 30

input : Signal Inputs.Input
input = sampleOn clock (lift7 Inputs.Input clock Inputs.chrono Inputs.keyboardInput 
  Inputs.otherKeyboardInput Inputs.mouseInput Window.dimensions raceInput)

gameState : Signal Game.GameState
gameState = foldp Steps.stepGame Game.defaultGame input

port raceOutput : Signal { position : { x: Float, y: Float}, direction: Float, velocity: Float, passedGates: [Float] }
port raceOutput = lift (Game.boatToOpponent . .boat) gameState

main = lift2 Render.render Window.dimensions gameState
