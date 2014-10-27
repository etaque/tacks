module Steps where

import Inputs (..)
import Game (..)
import Geo (..)
import Core (..)

import Maybe (..)
import Debug

mouseStep : MouseInput -> GameState -> GameState
mouseStep ({drag, mouse} as mouseInput) ({center} as gameState) =
  let newCenter = case drag of
        Just (x',y') -> let (x,y) = mouse in sub (floatify (x - x', y' - y)) center
        Nothing      -> center
  in  { gameState | center <- newCenter }

getCenterAfterMove : Point -> Point -> Point -> (Float,Float) -> (Point)
getCenterAfterMove (x,y) (x',y') (cx,cy) (w,h) =
  let refocus n n' c d margin =
        let min = c - (d / 2)
            mmin = min + margin
            max = c + (d / 2)
            mmax = max - margin
        in
          if | n < min || n > max -> c
             | n < mmin           -> if n' < n then c - (n - n') else c
             | n > mmax           -> if n' > n then c + (n' - n) else c
             | n' < mmin          -> c - (n - n')
             | n' > mmax          -> c + (n' - n)
             | otherwise          -> c
  in
    (refocus x x' cx w (w * 0.2), refocus y y' cy h (h * 0.4))

moveStep : Time -> Maybe PlayerState -> (Int,Int) -> GameState -> GameState
moveStep delta previousStateMaybe dims gameState =
  let newCenter = case gameState.watchMode of
        Watching playerId ->
          case findOpponent gameState.opponents playerId of
            Just playerState -> playerState.position
            Nothing -> gameState.center
        NotWatching ->
          case (previousStateMaybe, gameState.playerState) of
            (Just previousState, Just newState) ->
              getCenterAfterMove previousState.position newState.position gameState.center (floatify dims)
            _ ->
              gameState.center
  in  { gameState | center <- newCenter }

raceInputStep : RaceInput -> GameState -> GameState
raceInputStep raceInput gameState =
  let { playerId, playerState, now, startTime, course, opponents,
        wind, leaderboard, isMaster, watching } = raceInput
  in  { gameState | opponents <- opponents,
                    playerId <- playerId,
                    playerState <- playerState,
                    course <- maybe gameState.course identity course,
                    wind <- wind,
                    leaderboard <- leaderboard,
                    now <- now,
                    countdown <- mapMaybe (\st -> st - now) startTime,
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
    |> moveStep delta gameState.playerState windowInput
    |> mouseStep mouseInput
