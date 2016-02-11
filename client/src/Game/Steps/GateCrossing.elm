module Game.Steps.GateCrossing where

import Maybe as M
import List as L

import Model.Shared exposing (..)
import Game.Models exposing (..)
import Game.Geo exposing (..)
import Game.Core exposing (..)


gateCrossingStep : PlayerState -> GameState -> PlayerState -> PlayerState
gateCrossingStep previousState ({course} as gameState) ({crossedGates,position} as state) =
  let
    step = (previousState.position, position)
    started = isStarted gameState
    t = raceTime gameState

    newCrossedGates = case getNextGate course (L.length crossedGates) of

      Just StartLine ->
        if started && gateCrossedFromSouth course.downwind step
        then t :: crossedGates
        else crossedGates

      Just UpwindGate ->
        if gateCrossedFromSouth course.upwind step
        then t :: crossedGates
        else
          if gateCrossedFromSouth course.downwind step
          then L.tail crossedGates |> M.withDefault []
          else crossedGates

      Just DownwindGate ->
        if gateCrossedFromNorth course.downwind step
        then t :: crossedGates
        else
          if gateCrossedFromNorth course.upwind step
          then L.tail crossedGates |> M.withDefault []
          else crossedGates

      Nothing ->
        crossedGates

    nextGate = getNextGate course (L.length newCrossedGates)
  in
    { state
      | crossedGates = newCrossedGates
      , nextGate = nextGate
    }



getNextGate : Course -> Int -> Maybe GateLocation
getNextGate course crossedGates =
  if crossedGates == course.laps * 2 + 1
  then Nothing
  else
    if crossedGates == 0
    then Just StartLine
    else
      if crossedGates % 2 == 0
      then Just DownwindGate
      else Just UpwindGate


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
