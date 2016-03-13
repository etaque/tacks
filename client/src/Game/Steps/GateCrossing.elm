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
getNextGate started course crossedGatesCount =
  if crossedGatesCount == List.length course.gates + 1 then
    Nothing
  else if crossedGatesCount == 0 then
    Just course.start
  else
    CoreExtra.getAt (crossedGatesCount - 1) course.gates


gateCrossed : Gate -> Point -> Point -> Bool
gateCrossed gate p1 p2 =
  case gate.orientation of
    North ->
      toNorth gate ( p1, p2 )

    South ->
      toSouth gate ( p1, p2 )

    East ->
      toEast gate ( p1, p2 )

    West ->
      toWest gate ( p1, p2 )


toSouth : Gate -> Segment -> Bool
toSouth gate ( p, p' ) =
  (snd p) > (snd gate.center) && (snd p') <= (snd gate.center) && (gateCrossedInX gate ( p, p' ))


toNorth : Gate -> Segment -> Bool
toNorth gate ( p, p' ) =
  (snd p) < (snd gate.center) && (snd p') >= (snd gate.center) && (gateCrossedInX gate ( p, p' ))


toEast : Gate -> Segment -> Bool
toEast gate ( p1, p2 ) =
  (fst p1) < (fst gate.center) && (fst p2) >= (fst gate.center) && (gateCrossedInY) gate ( p1, p2 )


toWest : Gate -> Segment -> Bool
toWest gate ( p1, p2 ) =
  (fst p1) > (fst gate.center) && (fst p2) <= (fst gate.center) && (gateCrossedInY) gate ( p1, p2 )


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


gateCrossedInY : Gate -> Segment -> Bool
gateCrossedInY gate ( ( x, y ), ( x', y' ) ) =
  False
