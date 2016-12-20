module Game.Steps.Turning exposing (..)

import Game.Input exposing (..)
import Game.Shared exposing (..)
import Game.Utils as Utils
import Maybe.Extra as Maybe


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
            Utils.ensure360 (state.heading + turn)

        windAngle =
            Utils.angleDelta heading state.windOrigin

        newControlMode =
            if manualTurn input then
                FixedHeading
            else if lock || targetReached then
                FixedAngle
            else
                state.controlMode

        turning =
            getTurnCoeff input.arrows.x elapsed state.turning
    in
        { state
            | heading = heading
            , windAngle = windAngle
            , turning = turning
            , tackTarget = tackTarget
            , controlMode = newControlMode
        }


tackTargetReached : PlayerState -> Bool
tackTargetReached state =
    Maybe.map (\target -> abs (Utils.angleDelta state.windAngle target) < 1) state.tackTarget
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
    if input.arrows.y == -1 then
        Just (windAngleOnVmg state)
    else
        Nothing


getTurn : Maybe Float -> PlayerState -> KeyboardInput -> Float -> Float
getTurn tackTarget state input elapsed =
    case state.turning of
        Just turnCoeff ->
            elapsed * turnCoeff

        Nothing ->
            case tackTarget of
                Just t ->
                    -- tack target in progress on fixed angle mode
                    let
                        turn =
                            elapsed * autoTack

                        targetDelta =
                            Utils.angleDelta t state.windAngle
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
                            Utils.ensure360 (state.windOrigin + state.windAngle - state.heading)


getTurnCoeff : Int -> Float -> Maybe Float -> Maybe Float
getTurnCoeff x elapsed maybePrevTurnCoeff =
    case maybePrevTurnCoeff of
        Just prevTurnCoeff ->
            if x < 0 && prevTurnCoeff < 0 || x > 0 && prevTurnCoeff > 0 then
                -- still turning in same direction
                if prevTurnCoeff < maxTurnCoeff then
                    let
                        newTurnCoeff =
                            prevTurnCoeff + toFloat x * elapsed * turnCoeffAccel
                    in
                        if newTurnCoeff > 0 then
                            Just (min maxTurnCoeff newTurnCoeff)
                        else
                            Just (max -maxTurnCoeff newTurnCoeff)
                else
                    Just prevTurnCoeff
            else
                let
                    sense =
                        if x == 0 then
                            Utils.sign -prevTurnCoeff
                        else
                            x

                    newCoeff =
                        prevTurnCoeff + (toFloat sense * elapsed * turnCoeffAccel)
                in
                    if Utils.sign newCoeff == Utils.sign prevTurnCoeff then
                        Just newCoeff
                    else
                        Nothing

        Nothing ->
            if x /= 0 then
                Just (toFloat x * elapsed * turnCoeffAccel)
            else
                Nothing


autoTack : Float
autoTack =
    0.09


maxTurnCoeff : Float
maxTurnCoeff =
    0.11


turnCoeffAccel : Float
turnCoeffAccel =
    maxTurnCoeff / 200
