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

moveStep : Bool -> Time -> PlayerState -> (Int,Int) -> GameState -> GameState
moveStep frozen delta ({position,velocity,heading} as previous) dims ({playerState,center} as gameState) =
  let newPosition = playerState.position
      movedPlayer = { playerState | position <- playerState.position }
      newCenter = getCenterAfterMove position newPosition center (floatify dims)
  in  { gameState | playerState <- movedPlayer,
                    center <- newCenter }

raceInputStep : RaceInput -> GameState -> GameState
raceInputStep raceInput gameState =
  let { now, startTime, course, playerState, opponents,
        wind, leaderboard, isMaster } = raceInput
  in  { gameState | opponents <- opponents,
                    playerState <- maybe gameState.playerState identity playerState,
                    course <- maybe gameState.course identity course,
                    wind <- wind,
                    leaderboard <- leaderboard,
                    now <- now,
                    countdown <- mapMaybe (\st -> st - now) startTime,
                    isMaster <- isMaster }

stepGame : Input -> GameState -> GameState
stepGame input gameState =
  let frozen = input.raceInput.now == gameState.now
      previousState = gameState.playerState
  in  raceInputStep input.raceInput gameState
        |> moveStep frozen input.delta previousState input.windowInput
        |> mouseStep input.mouseInput
