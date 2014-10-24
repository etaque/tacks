module Steps where

import Inputs (..)
import Game (..)
import Geo (..)
import Core (..)

import Maybe (..)

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
  case (previousStateMaybe, gameState.playerState) of
    (Just previousState, Just newState) ->
      let newCenter = getCenterAfterMove previousState.position newState.position gameState.center (floatify dims)
      in  { gameState | center <- newCenter }
    _ -> gameState

raceInputStep : RaceInput -> GameState -> GameState
raceInputStep raceInput gameState =
  let { now, startTime, course, playerState, opponents,
        wind, leaderboard, isMaster } = raceInput
  in  { gameState | opponents <- opponents,
                    playerState <- playerState,
                    course <- maybe gameState.course identity course,
                    wind <- wind,
                    leaderboard <- leaderboard,
                    now <- now,
                    countdown <- mapMaybe (\st -> st - now) startTime,
                    isMaster <- isMaster }

stepGame : Input -> GameState -> GameState
stepGame input gameState =
  raceInputStep input.raceInput gameState
    |> moveStep input.delta gameState.playerState input.windowInput
    |> mouseStep input.mouseInput
