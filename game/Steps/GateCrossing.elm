module Steps.GateCrossing where

import Game (..)
import Geo (..)
import Core (..)

import Maybe as M
import List as L


gateCrossingStep : PlayerState -> GameState -> PlayerState -> PlayerState
gateCrossingStep previousState {course,countdown,now} ({crossedGates,position} as state) =
  let
    step = (previousState.position, position)
    started = isStarted countdown

    newCrossedGates = case getNextGate course (L.length crossedGates) of

      Just StartLine ->
        if | started && gateCrossedFromSouth course.downwind step -> now :: crossedGates
           | otherwise                                            -> crossedGates

      Just UpwindGate ->
        if | gateCrossedFromSouth course.upwind step   -> now :: crossedGates
           | gateCrossedFromSouth course.downwind step -> L.tail crossedGates
           | otherwise                                 -> crossedGates

      Just DownwindGate ->
        if | gateCrossedFromNorth course.downwind step -> now :: crossedGates
           | gateCrossedFromNorth course.upwind step   -> L.tail crossedGates
           | otherwise                                 -> crossedGates

      Nothing ->
        crossedGates

    nextGate = getNextGate course (L.length newCrossedGates)
  in
    { state
      | crossedGates <- newCrossedGates
      , nextGate <- nextGate
    }



getNextGate : Course -> Int -> Maybe GateLocation
getNextGate course crossedGates =
  if | crossedGates == course.laps * 2 + 1 -> Nothing
     | crossedGates == 0                   -> Just StartLine
     | crossedGates % 2 == 0               -> Just DownwindGate
     | otherwise                           -> Just UpwindGate


gateCrossedInX : Gate -> Segment -> Bool
gateCrossedInX gate ((x,y),(x',y')) =
  let a = (y - y') / (x - x')
      b = y - a * x
      xGate = (gate.y - b) / a
  in
    (abs xGate) <= gate.width / 2

gateCrossedFromNorth : Gate -> Segment -> Bool
gateCrossedFromNorth gate (p,p') =
  (snd p) > gate.y && (snd p') <= gate.y && (gateCrossedInX gate (p,p'))

gateCrossedFromSouth : Gate -> Segment -> Bool
gateCrossedFromSouth gate (p,p') =
  (snd p) < gate.y && (snd p') >= gate.y && (gateCrossedInX gate (p,p'))