module ShiftMaster where

import Window
import Keyboard
import WebSocket
import Json

import Inputs
import Game
import Steps
import Render.All as R

-- ports can't expand type alias for the moment... ugly manual expansion...
port raceInput : Signal 
  { now: Float
  , startTime: Maybe Float
  , course: Maybe 
              { upwind: { y: Float, width: Float }
              , downwind: { y: Float, width: Float }
              , laps: Int
              , markRadius: Float
              , islands: [{ location : (Float,Float), radius : Float }]
              , bounds: ((Float,Float),(Float,Float))
              }
  , crossedGates: [Float]
  , nextGate: Maybe String
  , wind: 
      { origin : Float
      , speed : Float
      , gusts : [{ position: (Float,Float), angle: Float, speed: Float, radius: Float }] 
      }
  , opponents: [{ position: (Float,Float), direction: Float, velocity: Float, name: String }]
  , buoys: [{position: (Float,Float), radius: Float, spell: {kind: String}}]
  , playerSpell: Maybe { kind: String }
  , triggeredSpells: [{ kind: String }]
  , leaderboard: [String] 
  }

clock : Signal Float
clock = inSeconds <~ fps 30

input : Signal Inputs.Input
input = sampleOn clock (lift6 Inputs.Input clock Inputs.chrono Inputs.keyboardInput
                              Inputs.mouseInput Window.dimensions raceInput)

gameState : Signal Game.GameState
gameState = foldp Steps.stepGame Game.defaultGame input

port raceOutput : Signal 
  { position : (Float, Float)
  , direction: Float
  , velocity: Float
  , spellCast: Bool
  , startCountdown: Bool
  }
port raceOutput = lift (playerToRaceOutput . .player) gameState

playerToRaceOutput ({position, direction, velocity, spellCast, startCountdown} as player) =
  { position = position
  , direction = direction
  , velocity = velocity
  , spellCast = spellCast
  , startCountdown = startCountdown
  }

main = lift2 R.renderAll Window.dimensions gameState
