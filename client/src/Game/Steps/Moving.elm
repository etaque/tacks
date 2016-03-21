module Game.Steps.Moving (..) where

import List
import Dict
import Model.Shared exposing (..)
import Game.Models exposing (..)
import Game.Geo exposing (..)
import Game.Core exposing (..)
import Game.Steps.Util exposing (..)
import Constants exposing (hexRadius)
import Hexagons


maxAccel : Float
maxAccel =
  0.03


movingStep : Float -> Course -> PlayerState -> PlayerState
movingStep elapsed course state =
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
        isGrounded nextPosition course state.nextGate

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


isGrounded : Point -> Course -> Maybe Gate -> Bool
isGrounded p course nextGate =
  let
    gates =
      course.start :: course.gates

    marks =
      nextGate
        |> Maybe.map getGateMarks
        |> Maybe.map (\m -> [ fst m, snd m ])
        |> Maybe.withDefault []

    halfBoatWidth =
      boatWidth / 2

    stuckOnMark =
      exists (\m -> (distance p m) <= markRadius + halfBoatWidth) marks

    currentTile =
      Dict.get (Hexagons.pointToAxial hexRadius p) course.grid

    onGround =
      currentTile /= Just Water
  in
    stuckOnMark || onGround
