module Steps.Turning where

import Inputs (..)
import Game (..)
import Geo (..)
import Core (..)

import Maybe as M
import List as L


slow = 0.03
autoTack = 0.08
fast = 0.1


turningStep : Float -> KeyboardInput -> PlayerState -> PlayerState
turningStep elapsed input state =
  let
    lock = input.lock || input.arrows.x > 0

    targetReached = tackTargetReached state
    tackTarget = getTackTarget state input targetReached

    turn = getTurn tackTarget state input elapsed
    heading = ensure360 (state.heading + turn)
    windAngle = angleDelta heading state.windOrigin

    newControlMode =
      if | manualTurn input -> "FixedHeading"
         | lock || targetReached -> "FixedAngle"
         | otherwise -> state.controlMode
  in
    { state
      | heading <- heading
      , windAngle <- windAngle
      , isTurning <- isTurning input
      , tackTarget <- tackTarget
      , controlMode <- newControlMode
    }


tackTargetReached : PlayerState -> Bool
tackTargetReached state =
  M.map (\target -> abs (angleDelta state.windAngle target) < 1) state.tackTarget
    |> M.withDefault false


getTackTarget : PlayerState -> KeyboardInput -> Bool -> Maybe Float
getTackTarget state input targetReached =
  if input.manualTurn then
    -- a manual turn means no tack
    Nothing
  else
    -- no manual turn => any previous tack in progress?
    case state.tackTarget of
      Just _ ->
        -- yes => check target
        if targetReached then Nothing else state.tackTarget
      Nothing ->
        -- no => maybe player triggered one
        if input.tack then Just -state.windAngle else autoVmgTarget state input


autoVmgTarget : PlayerState -> KeyboardInput -> Maybe Float
autoVmgTarget state input =
  if not (L.isEmpty state.crossedGates) &&
      state.isTurning &&
      not (manualTurn input) &&
      (abs (deltaToVmg state)) < state.player.vmgMagnet
    Just (windAngleOnVmg state)
  else
    Nothing


getTurn : Maybe Float -> PlayerState -> KeyboardInput -> Float -> Float
getTurn tackTarget state input elapsed =
  if manualTurn input then
    input.arrows.x * elapsed * (if input.subtleTurn then slow else fast)
  else
    case tackTarget of

      Just t ->
        -- tack target in progress on fixed angle mode
        let
          turn = elapsed * autoTack
          targetDelta = angleDelta t state.windAngle
        in
          if abs targetDelta < abs turn then
            targetDelta
          else
            if targetDelta < 0 then -turn else turn

      Nothing ->
        case state.controlMode of
          "FixedHeading" ->
            -- no tack, fixed heading => no turn
            0
          "FixedAngle" ->
            -- no tack, fixed angle => adapt to wind origin
            ensure360 (state.windOrigin + state.windAngle - state.heading)
