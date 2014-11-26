module Steps where

import Inputs (..)
import Game (..)
import Geo (..)
import Core (..)

import Maybe (..)

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
                    course <- maybe gameState.course identity course,
                    wind <- wind,
                    leaderboard <- leaderboard,
                    now <- now,
                    countdown <- mapMaybe (\st -> st - now) startTime,
                    gameMode <- gameMode,
                    isMaster <- isMaster }

watchStep : WatcherInput -> GameState -> GameState
watchStep input gameState =
  let watchMode = case (input.watchedPlayerId, gameState.watchMode) of
        (Just id, _)           -> Watching id
        (Nothing, NotWatching) -> Watching gameState.playerId
        _                      -> gameState.watchMode
  in  { gameState | watchMode <- watchMode }

stepGame : GameInput -> GameState -> GameState
stepGame {raceInput, delta, windowInput, mouseInput, watcherInput} gameState =
  raceInputStep raceInput gameState
    |> (if raceInput.watching then watchStep watcherInput else identity)
    |> centerStep
