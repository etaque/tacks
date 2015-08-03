module Steps where

import Inputs exposing (..)
import Game exposing (..)
import State exposing (..)
import Geo exposing (..)
import Core exposing (..)

import Steps.GateCrossing exposing (gateCrossingStep)
import Steps.Moving exposing (movingStep)
import Steps.Turning exposing (turningStep)
import Steps.Vmg exposing (vmgStep)
import Steps.Wind exposing (windStep)

import Forms.Update as FormsUpdate

import Maybe as M
import List as L


mainStep : AppInput -> AppState -> AppState
mainStep appInput appState =
  let
    newAppState = actionStep appInput.action appState

    newGameState = case newAppState.screen of
      Play raceCourse ->
        let
          gameState = M.withDefault (initGameState appInput.clock newAppState raceCourse) appState.gameState
        in
          case appInput.action of
            GameUpdate gameInput ->
              Just (gameStep gameInput gameState)
            _ ->
              Just gameState
      _ ->
        Nothing
  in
    { newAppState | gameState <- newGameState }

initGameState : Inputs.Clock -> AppState -> RaceCourse -> GameState
initGameState clock appState raceCourse =
  defaultGame clock.time raceCourse.course appState.player

actionStep : Action -> AppState -> AppState
actionStep action appState =
  case action of

    Navigate newScreen ->
      { appState | screen <- newScreen }

    LiveUpdate input ->
      { appState | courses <- input.raceCourses }

    PlayerUpdate player ->
      { appState | player <- player }

    FormAction updateForm ->
      { appState | forms <- FormsUpdate.updateForms updateForm appState.forms }

    _ ->
      appState


gameStep : GameInput -> GameState -> GameState
gameStep {raceInput, clock, windowInput, keyboardInput} gameState =
  raceInputStep raceInput clock gameState
    |> playerStep keyboardInput clock.delta
    |> centerStep


--

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
    { serverNow, startTime, opponents, ghosts, leaderboard, initial, clientTime } = raceInput

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

    wind = raceInput.wind

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
      , live <- not initial
      , localTime <- time
      , roundTripDelay <- roundTripDelay
    }

playerTimeStep : Float -> PlayerState -> PlayerState
playerTimeStep elapsed state =
  { state | time <- state.time + elapsed }

runEscapeStep : Bool -> PlayerState -> PlayerState
runEscapeStep doEscape playerState =
  let
    crossedGates = if doEscape then [] else playerState.crossedGates
  in
    { playerState | crossedGates <- crossedGates }

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
        |> runEscapeStep keyboardInput.escapeRun
  in
    { gameState | playerState <- playerState }
