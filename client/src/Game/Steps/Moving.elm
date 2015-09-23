module Game.Steps.Moving where

import List as L

import Models exposing (..)
import Game.Models exposing (..)
import Game.Geo exposing (..)
import Game.Grid exposing (currentTile)
import Game.Core exposing (..)
import Game.Steps.Util exposing (..)


maxAccel : Float
maxAccel = 0.03


movingStep : Float -> Course -> PlayerState -> PlayerState
movingStep elapsed course state =
  if elapsed == 0 then
    state
  else
    let
      baseSpeed = polarSpeed state.windSpeed state.windAngle
      nextVelocity = withInertia elapsed state.velocity baseSpeed

      nextPosition = movePoint state.position elapsed nextVelocity state.heading

      grounded = isGrounded nextPosition course

      velocity = if grounded then 0 else nextVelocity
      position = if grounded then state.position else nextPosition

      trail = L.take 20 (position :: state.trail)
    in
      { state
        | isGrounded <- grounded
        , velocity <- velocity
        , position <- position
        , trail <- trail
      }


withInertia : Float -> Float -> Float -> Float
withInertia elapsed previousVelocity targetVelocity =
  let
    velocityDelta = targetVelocity - previousVelocity
    accel = velocityDelta / elapsed
    realAccel = if accel > 0
      then min accel maxAccel
      else max accel -maxAccel
  in
    previousVelocity + realAccel * elapsed


isGrounded : Point -> Course -> Bool
isGrounded p course =
  let
    (dl, dr) = getGateMarks course.downwind
    (ul, ur) = getGateMarks course.upwind
    marks = [dl, dr, ul, ur]
    halfBoatWidth = boatWidth / 2

    stuckOnMark = exists (\m -> (distance p m) <= markRadius + halfBoatWidth) marks
    onGround = (currentTile course.grid p) /= Just Water
  in
    stuckOnMark || onGround
