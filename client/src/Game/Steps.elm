module Game.Steps where

import Task

import AppTypes exposing (..)
import Models exposing (..)
import Game.Inputs exposing (..)
import Game.Models exposing (..)
import Game.Geo exposing (..)
import Game.Core exposing (..)

import Game.Steps.GateCrossing exposing (gateCrossingStep)
import Game.Steps.Moving exposing (movingStep)
import Game.Steps.Turning exposing (turningStep)
import Game.Steps.Vmg exposing (vmgStep)
import Game.Steps.Wind exposing (windStep)


gameStep : Clock -> GameInput -> GameState -> GameState
gameStep clock {raceInput, windowInput, keyboardInput} gameState =
  let
    keyboardInputWithFocus =
      if gameState.chatting
        then emptyKeyboardInput
        else keyboardInput
  in
    raceInputStep raceInput clock gameState
      |> playerStep keyboardInputWithFocus clock.delta
      |> centerStep


--

raceInputStep : RaceInput -> Clock -> GameState -> GameState
raceInputStep raceInput {delta,time} ({playerState} as gameState) =
  let
    { serverNow, startTime, opponents, ghosts, tallies, initial, clientTime } = raceInput

    rtd = case gameState.rtd of
      Just previousRtd ->
        min previousRtd (time - clientTime)
      Nothing ->
        time - clientTime

    compensedServerNow = serverNow - (rtd / 2)

    now = case gameState.serverNow of
      Just previousServerNow ->
        min (previousServerNow + delta) compensedServerNow
      Nothing ->
        compensedServerNow

    updatedOpponents = updateOpponents gameState.opponents delta opponents

    newPlayerState = { playerState | time <- now }

    windHistory = updateWindHistory raceInput.wind gameState.windHistory

  in
    { gameState
      | opponents <- updatedOpponents
      , ghosts <- ghosts
      , wind <- raceInput.wind
      , windHistory <- windHistory
      , tallies <- tallies
      , serverNow <- Just serverNow
      , now <- now
      , playerState <- newPlayerState
      , startTime <- startTime
      , live <- not initial
      , localTime <- time
      , rtd <- Just rtd
    }

updateWindHistory : Wind -> WindHistory -> WindHistory
updateWindHistory {origin, speed} h =
  if h.sampleCounter >= 5 then
    WindHistory (origin :: h.origins) (speed :: h.speeds) 0
  else
    { h | sampleCounter <- h.sampleCounter + 1 }



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
        |> raceEscapeStep keyboardInput.escapeRace
  in
    { gameState | playerState <- playerState }


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
    List.map (\o -> updateOpponent (findPrevious o) delta o) newOpponents

playerTimeStep : Float -> PlayerState -> PlayerState
playerTimeStep elapsed state =
  { state | time <- state.time + elapsed }

raceEscapeStep : Bool -> PlayerState -> PlayerState
raceEscapeStep doEscape playerState =
  let
    crossedGates = if doEscape then [] else playerState.crossedGates
  in
    { playerState | crossedGates <- crossedGates }
