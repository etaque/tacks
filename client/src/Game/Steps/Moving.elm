module Game.Steps.Moving exposing (..)

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


playerStep : Float -> Bool -> Course -> PlayerState -> PlayerState
playerStep elapsed started course state =
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


opponentStep : Float -> Bool -> Course -> OpponentState -> OpponentState
opponentStep elapsed started course state =
    if elapsed == 0 then
        state
    else
        let
            nextPosition =
                movePoint state.position elapsed state.velocity state.heading

            grounded =
                isGrounded
                    started
                    state.position
                    nextPosition
                    course
                    (List.length state.crossedGates)

            position =
                if grounded then
                    state.position
                else
                    nextPosition
        in
            { state | position = position }


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
                |> List.map Tuple.second

        marks =
            visibleGates
                |> List.map getGateMarks
                |> List.concatMap (\m -> [ Tuple.first m, Tuple.second m ])

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
