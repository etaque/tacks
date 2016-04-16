module Game.Steps.Moving (..) where

import List
import Dict
import Model.Shared exposing (..)
import Game.Models exposing (..)
import Game.Geo exposing (..)
import Game.Core exposing (..)
import Game.Steps.Util exposing (..)
import Game.Steps.GateCrossing as GateCrossing
import Constants exposing (hexRadius)
import Hexagons


maxAccel : Float
maxAccel =
  0.03


movingStep : Float -> Bool -> Course -> PlayerState -> PlayerState
movingStep elapsed started course state =
  if elapsed == 0 then
    state
  else
    let
      baseSpeed =
        polarSpeed state.windSpeed state.windAngle

      nextVelocity =
        withInertia elapsed state.velocity baseSpeed

      nextPosition =
        movePoint state.position elapsed nextVelocity state.heading

      grounded =
        isGrounded
          started
          state.position
          nextPosition
          course
          (List.length state.crossedGates)

      velocity =
        if grounded then
          0
        else
          nextVelocity

      position =
        if grounded then
          state.position
        else
          nextPosition

      trail =
        List.take 20 (position :: state.trail)
    in
      { state
        | isGrounded = grounded
        , velocity = velocity
        , position = position
        , trail = trail
      }


withInertia : Float -> Float -> Float -> Float
withInertia elapsed previousVelocity targetVelocity =
  let
    velocityDelta =
      targetVelocity - previousVelocity

    accel =
      velocityDelta / elapsed

    realAccel =
      if accel > 0 then
        min accel maxAccel
      else
        max accel -maxAccel
  in
    previousVelocity + realAccel * elapsed


isGrounded : Bool -> Point -> Point -> Course -> Int -> Bool
isGrounded started oldPosition newPosition course crossedGatesCount =
  let
    gateIsVisible ( i, g ) =
      abs (i - crossedGatesCount) <= 1

    visibleGates =
      (course.start :: course.gates)
        |> List.indexedMap (,)
        |> List.filter gateIsVisible
        |> List.map snd

    marks =
      visibleGates
        |> List.map getGateMarks
        |> List.concatMap (\m -> [ fst m, snd m ])

    halfBoatWidth =
      boatWidth / 2

    stuckOnMark =
      exists (\m -> (distance newPosition m) <= markRadius + halfBoatWidth) marks

    stuckOnStartLine =
      not started && startLineCrossed oldPosition newPosition course.start

    currentTile =
      Dict.get (Hexagons.pointToAxial hexRadius newPosition) course.grid

    onGround =
      currentTile /= Just Water
  in
    stuckOnMark || stuckOnStartLine || onGround


startLineCrossed : Point -> Point -> Gate -> Bool
startLineCrossed oldPosition newPosition gate =
  GateCrossing.gateCrossed gate oldPosition newPosition
    || GateCrossing.gateCrossed (GateCrossing.revertGate gate) oldPosition newPosition
