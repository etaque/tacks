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

port raceInput : Signal { startTime: Float, opponents: [{ position : { x: Float, y: Float}, direction: Float, velocity: Float }]}

--clock : Inputs.GameClock
clock = timestamp (inSeconds <~ fps 30)

input : Signal Inputs.Input
input = sampleOn clock (lift7 Inputs.Input clock Inputs.chrono Inputs.keyboardInput 
  Inputs.otherKeyboardInput Inputs.mouseInput Window.dimensions raceInput)

gameState : Signal Game.GameState
gameState = foldp Steps.stepGame Game.defaultGame input

boatJson = lift (\g -> Game.boatToJson g.boat) gameState

boatStateJson : Signal String
boatStateJson = lift (Json.toString "") boatJson

port raceOutput : Signal { position : { x: Float, y: Float}, direction: Float, velocity: Float }
port raceOutput = lift (Game.boatToOpponent . .boat) gameState

main = lift2 Render.render Window.dimensions gameState
