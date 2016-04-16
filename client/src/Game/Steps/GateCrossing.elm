module Game.Steps.GateCrossing (..) where

import CoreExtra
import Model.Shared exposing (..)
import Game.Models exposing (..)


gateCrossingStep : PlayerState -> GameState -> PlayerState -> PlayerState
gateCrossingStep previousState ({ course } as gameState) ({ crossedGates, position } as state) =
  let
    prevGateMaybe =
      getNextGate course (List.length crossedGates - 1)

    nextGateMaybe =
      getNextGate course (List.length crossedGates)

    newCrossedGates =
      case nextGateMaybe of
        Just nextGate ->
          if isStarted gameState then
            if gateCrossed nextGate previousState.position position then
              (raceTime gameState) :: crossedGates
            else
              case prevGateMaybe of
                Just prevGate ->
                  if gateCrossed (revertGate prevGate) previousState.position position then
                    List.tail crossedGates |> Maybe.withDefault []
                  else
                    crossedGates

                Nothing ->
                  crossedGates
          else
            crossedGates

        Nothing ->
          crossedGates

    nextGate =
      getNextGate course (List.length newCrossedGates)
  in
    { state
      | crossedGates = newCrossedGates
      , nextGate = nextGate
    }


getNextGate : Course -> Int -> Maybe Gate
getNextGate course crossedGatesCount =
  if crossedGatesCount == List.length course.gates + 1 then
    Nothing
  else if crossedGatesCount == 0 then
    Just course.start
  else
    CoreExtra.getAt (crossedGatesCount - 1) course.gates


revertGate : Gate -> Gate
revertGate gate =
  let
    newOrientation =
      case gate.orientation of
        North ->
          South

        South ->
          North

        East ->
          West

        West ->
          East
  in
    { gate | orientation = newOrientation }


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
toSouth gate ( p1, p2 ) =
  snd p1 > snd gate.center && snd p2 <= snd gate.center && horizontalIntersect gate ( p1, p2 )


toNorth : Gate -> Segment -> Bool
toNorth gate ( p1, p2 ) =
  snd p1 < snd gate.center && snd p2 >= snd gate.center && horizontalIntersect gate ( p1, p2 )


toEast : Gate -> Segment -> Bool
toEast gate ( p1, p2 ) =
  fst p1 < fst gate.center && fst p2 >= fst gate.center && verticalIntersect gate ( p1, p2 )


toWest : Gate -> Segment -> Bool
toWest gate ( p1, p2 ) =
  fst p1 > fst gate.center && fst p2 <= fst gate.center && verticalIntersect gate ( p1, p2 )


{-| North, South
-}
horizontalIntersect : Gate -> Segment -> Bool
horizontalIntersect gate seg =
  let
    ( a, b ) =
      lineAB seg

    x =
      (snd gate.center - b) / a

    xRel =
      x - fst gate.center
  in
    (abs xRel) <= gate.width / 2


{-| East, West
-}
verticalIntersect : Gate -> Segment -> Bool
verticalIntersect gate seg =
  let
    ( a, b ) =
      lineAB seg

    y =
      a * (fst gate.center) + b

    yRel =
      y - snd gate.center
  in
    (abs yRel) <= gate.width / 2


lineAB : Segment -> ( Float, Float )
lineAB ( ( x, y ), ( x', y' ) ) =
  let
    a =
      (y - y') / (x - x')

    b =
      y - a * x
  in
    ( a, b )
