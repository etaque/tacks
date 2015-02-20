module Steps where

import Inputs (..)
import Game (..)
import Geo (..)
import Core (..)

import Steps.GateCrossing (gateCrossingStep)
import Steps.Moving (movingStep)
import Steps.Turning (turningStep)
import Steps.Vmg (vmgStep)
import Steps.Wind (windStep)

import Maybe as M


centerStep : GameState -> GameState
centerStep gameState =
  let newCenter = gameState.playerState.position
  in  { gameState | center <- newCenter }

raceInputStep : RaceInput -> GameState -> GameState
raceInputStep raceInput gameState =
  let { now, startTime, opponents, ghosts,
        wind, leaderboard, isMaster } = raceInput
  in  { gameState | opponents <- opponents,
                    ghosts <- ghosts,
                    wind <- wind,
                    leaderboard <- leaderboard,
                    now <- now,
                    countdown <- M.map (\st -> st - now) startTime,
                    isMaster <- isMaster }

playerStep : KeyboardInput -> Float -> GameState -> GameState
playerStep keyboardInput elapsed gameState =
  let
    newPlayerState =
      turningStep elapsed keyboardInput gameState.playerState
        |> windStep gameState
        |> vmgStep
        |> movingStep elapsed gameState.course
        |> gateCrossingStep gameState.playerState gameState
  in
    { gameState | playerState <- newPlayerState }


stepGame : GameInput -> GameState -> GameState
stepGame {raceInput, delta, windowInput, keyboardInput} gameState =
  raceInputStep raceInput gameState
    |> playerStep keyboardInput delta
    |> centerStep
