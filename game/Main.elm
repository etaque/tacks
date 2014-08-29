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
port raceInput : Signal { now: Float, startTime: Float,
                          course: Maybe { upwind: { y: Float, width: Float }, downwind: { y: Float, width: Float }, laps: Int,
                                          markRadius: Float, islands: [{ location : (Float,Float), radius : Float }],
                                          bounds: ((Float,Float),(Float,Float)) },
                          opponents: [{ position: (Float,Float), direction: Float, velocity: Float, passedGates: [Float], name: String }],
                          playerSpell: Maybe { kind: String },
                          triggeredSpells: [{ kind: String }],
                          leaderboard: [String] }

clock : Signal Float
clock = inSeconds <~ fps 30

input : Signal Inputs.Input
input = sampleOn clock (lift6 Inputs.Input clock Inputs.chrono Inputs.keyboardInput
                              Inputs.mouseInput Window.dimensions raceInput)

gameState : Signal Game.GameState
gameState = foldp Steps.stepGame Game.defaultGame input

port raceOutput : Signal { position : (Float, Float), direction: Float, velocity: Float, passedGates: [Float], spellCast: Bool }
port raceOutput = lift (playerToRaceOutput . .player) gameState

playerToRaceOutput ({position, direction, velocity, passedGates, spellCast} as player) =
  { position = position
  , direction = direction
  , velocity = velocity
  , passedGates = passedGates
  , spellCast = spellCast
  }

main = lift2 R.renderAll Window.dimensions gameState
