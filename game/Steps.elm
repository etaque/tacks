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
import List as L
import Debug

centerStep : GameState -> GameState
centerStep gameState =
  let newCenter = gameState.playerState.position
  in  { gameState | center <- newCenter }


moveOpponentState : OpponentState -> Float -> OpponentState
moveOpponentState state delta =
  let
    position = movePoint state.position delta state.velocity state.heading
  in
    { state | position <- position }


updateOpponent : Maybe Opponent -> Float -> Opponent -> Opponent
updateOpponent previousMaybe delta opponent =
  case previousMaybe of
    Just previous ->
      if previous.state.time == opponent.state.time then
        { opponent | state <- moveOpponentState opponent.state delta }
      else
        opponent
    Nothing ->
      opponent

updateOpponents : List Opponent -> Float -> List Opponent -> List Opponent
updateOpponents previousOpponents delta newOpponents =
  let
    findPrevious o = find (\po -> po.player.id == o.player.id) previousOpponents
  in
    L.map (\o -> updateOpponent (findPrevious o) delta o) newOpponents

raceInputStep : RaceInput -> Clock -> GameState -> GameState
raceInputStep raceInput {delta,time} ({playerState} as gameState) =
  let
    { serverNow, startTime, opponents, ghosts, wind, leaderboard, isMaster, initial, clientTime } = raceInput

    stalled = serverNow == gameState.serverNow

    roundTripDelay = if stalled then
      gameState.roundTripDelay
    else
      time - clientTime

    now = if gameState.live then
      gameState.now + delta
    else
      serverNow

    updatedOpponents = updateOpponents gameState.opponents delta opponents

    newPlayerState = { playerState | time <- now }
  in
    { gameState
      | opponents <- updatedOpponents
      , ghosts <- ghosts
      , wind <- wind
      , leaderboard <- leaderboard
      , serverNow <- serverNow
      , now <- now
      , playerState <- newPlayerState
      , startTime <- startTime
      , isMaster <- isMaster
      , live <- not initial
      , localTime <- time
      , roundTripDelay <- roundTripDelay
    }

playerTimeStep : Float -> PlayerState -> PlayerState
playerTimeStep elapsed state =
  { state | time <- state.time + elapsed }


playerStep : KeyboardInput -> Float -> GameState -> GameState
playerStep keyboardInput elapsed gameState =
  let
    playerState =
      turningStep elapsed keyboardInput gameState.playerState
        |> windStep gameState
        |> vmgStep
        |> movingStep elapsed gameState.course
        |> gateCrossingStep gameState.playerState gameState
        |> playerTimeStep elapsed
  in
    { gameState | playerState <- playerState }


stepGame : GameInput -> GameState -> GameState
stepGame {raceInput, clock, windowInput, keyboardInput} gameState =
  raceInputStep raceInput clock gameState
    |> playerStep keyboardInput clock.delta
    |> centerStep
