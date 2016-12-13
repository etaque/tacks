module Game.Steps.Turning exposing (..)

import Game.Inputs exposing (..)
import Game.Models exposing (..)
import Game.Geo exposing (..)


slow : Float
slow =
    0.03


autoTack : Float
autoTack =
    0.08


fast : Float
fast =
    0.1


turningStep : Float -> KeyboardInput -> PlayerState -> PlayerState
turningStep elapsed input state =
    let
        lock =
            input.lock || input.arrows.y > 0

        targetReached =
            tackTargetReached state

        tackTarget =
            getTackTarget state input targetReached

        turn =
            getTurn tackTarget state input elapsed

        heading =
            ensure360 (state.heading + turn)

        windAngle =
            angleDelta heading state.windOrigin

        newControlMode =
            if manualTurn input then
                FixedHeading
            else if lock || targetReached then
                FixedAngle
            else
                state.controlMode

        isTurning =
            manualTurn input && not input.subtleTurn
    in
        { state
            | heading = heading
            , windAngle = windAngle
            , isTurning = isTurning
            , tackTarget = tackTarget
            , controlMode = newControlMode
        }


tackTargetReached : PlayerState -> Bool
tackTargetReached state =
    Maybe.map (\target -> abs (angleDelta state.windAngle target) < 1) state.tackTarget
        |> Maybe.withDefault False


getTackTarget : PlayerState -> KeyboardInput -> Bool -> Maybe Float
getTackTarget state input targetReached =
    if manualTurn input then
        -- a manual turn means no tack
        Nothing
    else
        -- no manual turn => any previous tack in progress?
        case state.tackTarget of
            Just _ ->
                -- yes => check target
                if targetReached then
                    Nothing
                else
                    state.tackTarget

            Nothing ->
                -- no => maybe player triggered one
                if input.tack then
                    Just -state.windAngle
                else
                    autoVmgTarget state input


autoVmgTarget : PlayerState -> KeyboardInput -> Maybe Float
autoVmgTarget state input =
    if
        not (List.isEmpty state.crossedGates)
            && state.isTurning
            && not (manualTurn input)
            && (abs (deltaToVmg state))
            < (toFloat state.player.vmgMagnet)
    then
        Just (windAngleOnVmg state)
    else
        Nothing


getTurn : Maybe Float -> PlayerState -> KeyboardInput -> Float -> Float
getTurn tackTarget state input elapsed =
    if manualTurn input then
        (toFloat input.arrows.x)
            * elapsed
            * (if input.subtleTurn then
                slow
               else
                fast
              )
    else
        case tackTarget of
            Just t ->
                -- tack target in progress on fixed angle mode
                let
                    turn =
                        elapsed * autoTack

                    targetDelta =
                        angleDelta t state.windAngle
                in
                    if abs targetDelta < abs turn then
                        targetDelta
                    else if targetDelta < 0 then
                        -turn
                    else
                        turn

            Nothing ->
                case state.controlMode of
                    FixedHeading ->
                        -- no tack, fixed heading => no turn
                        0

                    FixedAngle ->
                        -- no tack, fixed angle => adapt to wind origin
                        ensure360 (state.windOrigin + state.windAngle - state.heading)
