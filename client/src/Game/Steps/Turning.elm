module Game.Steps.Turning exposing (..)

import Game.Shared exposing (..)
import Game.Utils as Utils
import Maybe.Extra as Maybe


turningStep : Float -> Int -> PlayerState -> PlayerState
turningStep elapsed direction state =
    let
        targetReached =
            tackTargetReached state

        tackTarget =
            Maybe.filter (\_ -> not targetReached) state.tackTarget

        turn =
            getTurn tackTarget state elapsed

        heading =
            Utils.ensure360 (state.heading + turn)

        windAngle =
            Utils.angleDelta heading state.windOrigin

        newControlMode =
            if direction /= 0 then
                FixedHeading
            else if targetReached then
                FixedAngle
            else
                state.controlMode

        turning =
            getTurnCoeff direction elapsed state.turning
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


getTurn : Maybe Float -> PlayerState -> Float -> Float
getTurn tackTarget state elapsed =
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
