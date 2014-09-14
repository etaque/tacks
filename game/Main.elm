module Main where

import Window
import Keyboard
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
              , windShadowLength: Float
              , boatWidth: Float
              }
  , player: Maybe
      { position : (Float,Float)
      , heading: Float
      , velocity: Float
      , windAngle: Float
      , windOrigin: Float
      , windSpeed: Float
      , downwindVmg: Float
      , upwindVmg: Float
      , trail: [(Float,Float)]
      , controlMode: String
      , tackTarget: Maybe Float
      , crossedGates: [Float]
      , nextGate: Maybe String
      , ownSpell: Maybe { kind: String }
      }
  , wind:
      { origin : Float
      , speed : Float
      , gusts : [{ position: (Float,Float), angle: Float, speed: Float, radius: Float }]
      }
  , opponents: [
    { position: (Float,Float)
    , heading: Float
    , velocity: Float
    , windAngle: Float
    , windOrigin: Float
    , windSpeed: Float
    , user: { name: String }
    }]
  , buoys: [{position: (Float,Float), radius: Float, spell: {kind: String}}]
  , leaderboard: [String]
  , triggeredSpells: [{ kind: String }]
  , isMaster: Bool
  }

clock : Signal Float
clock = inSeconds <~ fps 30

input : Signal Inputs.Input
input = sampleOn clock (lift6 Inputs.Input
  clock Inputs.chrono Inputs.keyboardInput Inputs.mouseInput Window.dimensions raceInput)

gameState : Signal Game.GameState
gameState = foldp Steps.stepGame Game.defaultGame input

port playerOutput : Signal
  { arrows: { x:Int, y:Int }
  , lock: Bool
  , tack: Bool
  , subtleTurn: Bool
  , spellCast: Bool
  , startCountdown: Bool
  }

port playerOutput = lift .keyboardInput input

main = lift2 R.renderAll Window.dimensions gameState
