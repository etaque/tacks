module Steps.GateCrossing where

import Game exposing (..)
import Geo exposing (..)
import Core exposing (..)

import Maybe as M
import List as L


gateCrossingStep : PlayerState -> GameState -> PlayerState -> PlayerState
gateCrossingStep previousState ({course} as gameState) ({crossedGates,position} as state) =
  let
    step = (previousState.position, position)
    started = isStarted gameState
    t = raceTime gameState

    newCrossedGates = case getNextGate course (L.length crossedGates) of

      Just StartLine ->
        if | started && gateCrossedFromSouth course.downwind step -> t :: crossedGates
           | otherwise                                            -> crossedGates

      Just UpwindGate ->
        if | gateCrossedFromSouth course.upwind step   -> t :: crossedGates
           | gateCrossedFromSouth course.downwind step -> L.tail crossedGates |> M.withDefault []
           | otherwise                                 -> crossedGates

      Just DownwindGate ->
        if | gateCrossedFromNorth course.downwind step -> t :: crossedGates
           | gateCrossedFromNorth course.upwind step   -> L.tail crossedGates |> M.withDefault []
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
