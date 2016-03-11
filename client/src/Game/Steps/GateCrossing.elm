module Game.Steps.GateCrossing (..) where

import CoreExtra
import Model.Shared exposing (..)
import Game.Models exposing (..)


gateCrossingStep : PlayerState -> GameState -> PlayerState -> PlayerState
gateCrossingStep previousState ({ course } as gameState) ({ crossedGates, position } as state) =
  let
    newCrossedGates =
      case getNextGate (isStarted gameState) course (List.length crossedGates) of
        Just gate ->
          if gateCrossed gate previousState.position position then
            (raceTime gameState) :: crossedGates
          else
            crossedGates

        Nothing ->
          crossedGates

    nextGate =
      getNextGate (isStarted gameState) course (List.length newCrossedGates)
  in
    { state
      | crossedGates = newCrossedGates
      , nextGate = nextGate
    }


getNextGate : Bool -> Course -> Int -> Maybe Gate
getNextGate started course crossedGates =
  if crossedGates == List.length course.gates + 1 then
    Nothing
  else if crossedGates == 0 then
    if started then
      Just course.start
    else
      Nothing
  else
    CoreExtra.getAt (crossedGates - 1) course.gates


gateCrossed : Gate -> Point -> Point -> Bool
gateCrossed gate p1 p2 =
  case gate.orientation of
    North ->
      gateCrossedFromSouth gate ( p1, p2 )

    South ->
      gateCrossedFromNorth gate ( p1, p2 )


gateCrossedFromNorth : Gate -> Segment -> Bool
gateCrossedFromNorth gate ( p, p' ) =
  (snd p) > (snd gate.center) && (snd p') <= (snd gate.center) && (gateCrossedInX gate ( p, p' ))


gateCrossedFromSouth : Gate -> Segment -> Bool
gateCrossedFromSouth gate ( p, p' ) =
  (snd p) < (snd gate.center) && (snd p') >= (snd gate.center) && (gateCrossedInX gate ( p, p' ))


gateCrossedInX : Gate -> Segment -> Bool
gateCrossedInX gate ( ( x, y ), ( x', y' ) ) =
  let
    a =
      (y - y') / (x - x')

    b =
      y - a * x

    xGate =
      (snd gate.center - b) / a
  in
    (abs xGate) <= gate.width / 2
