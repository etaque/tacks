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
  let newCenter = case gameState.watchMode of
        Watching playerId ->
          case findOpponent gameState.opponents playerId of
            Just playerState -> playerState.position
            Nothing          -> gameState.center
        NotWatching ->
          case gameState.playerState of
            Just state -> state.position
            Nothing    -> gameState.center
  in  { gameState | center <- newCenter }

raceInputStep : RaceInput -> GameState -> GameState
raceInputStep raceInput gameState =
  let { playerId, playerState, now, startTime, course, opponents, ghosts,
        wind, leaderboard, isMaster, watching, timeTrial } = raceInput
      gameMode = if timeTrial then TimeTrial else Race
  in  { gameState | opponents <- opponents,
                    ghosts <- ghosts,
                    playerId <- playerId,
                    playerState <- playerState,
                    course <- M.withDefault gameState.course course,
                    wind <- wind,
                    leaderboard <- leaderboard,
                    now <- now,
                    countdown <- M.map (\st -> st - now) startTime,
                    gameMode <- gameMode,
                    isMaster <- isMaster }

playerStep : KeyboardInput -> Float -> GameState -> GameState
playerStep keyboardInput elapsed gameState =
  case gameState.playerState of
    Just ps ->
      let
        newPlayerState =
          turningStep elapsed keyboardInput ps
            |> windStep gameState
            |> vmgStep
            |> movingStep elapsed gameState.course
            |> gateCrossingStep ps gameState
      in
        { gameState | playerState <- Just newPlayerState }
    Nothing ->
      gameState

watchStep : WatcherInput -> GameState -> GameState
watchStep input gameState =
  let watchMode = case (input.watchedPlayerId, gameState.watchMode) of
        (Just id, _)           -> Watching id
        (Nothing, NotWatching) -> Watching gameState.playerId
        _                      -> gameState.watchMode
  in  { gameState | watchMode <- watchMode }

stepGame : GameInput -> GameState -> GameState
stepGame {raceInput, delta, windowInput, watcherInput, keyboardInput} gameState =
  raceInputStep raceInput gameState
    |> playerStep keyboardInput delta
    |> (if raceInput.watching then watchStep watcherInput else identity)
    |> centerStep
