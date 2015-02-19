module Steps.Moving where

import Inputs (..)
import Game (..)
import Geo (..)
import Core (..)
import Steps.Util (..)

import Maybe as M
import List as L


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
      then L.minimum [accel, maxAccel]
      else L.maximum [accel, -maxAccel]
  in
    previousVelocity + realAccel * elapsed


isGrounded : Point -> Course -> Bool
isGrounded p course =
  let
    (dl, dr) = getGateMarks course.downwind
    (ul, ur) = getGateMarks course.upwind
    marks = [dl, dr, ul, ur]
    halfBoatWidth = course.boatWidth / 2

    stuckOnMark = exists (\m -> (distance p m) <= course.markRadius + halfBoatWidth) marks
    outOfBounds = not (inBox p (areaBox course.area))
    onIsland = exists (\i -> (distance i.location p) <= i.radius + halfBoatWidth) course.islands
  in
    stuckOnMark || outOfBounds || onIsland

