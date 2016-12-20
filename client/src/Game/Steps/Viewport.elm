module Game.Steps.Viewport exposing (..)

import Model.Shared exposing (..)
import Game.Shared exposing (..)
import Game.Utils as Utils
import Constants


viewportStep : Point -> ( Int, Int ) -> GameState -> GameState
viewportStep ( px, py ) dims ({ center, playerState, course } as gameState) =
    let
        ( cx, cy ) =
            center

        ( px_, py_ ) =
            playerState.position

        ( w, h ) =
            Utils.floatify dims

        ( ( xMax, yMax ), ( xMin, yMin ) ) =
            areaBox course.area

        newCenter =
            ( axisCenter px px_ cx w xMin xMax
            , axisCenter py py_ cy h yMin yMax
            )
    in
        { gameState | center = newCenter }


axisCenter : Float -> Float -> Float -> Float -> Float -> Float -> Float
axisCenter p p_ c window areaMin areaMax =
    let
        offset =
            (window / 2) - (window * 0.48)

        outOffset =
            (window / 2) - Constants.hexRadius

        delta =
            p_ - p

        minExit =
            delta < 0 && p_ < c - offset

        maxExit =
            delta > 0 && p_ > c + offset
    in
        if minExit then
            if areaMin > c - outOffset then
                c
            else
                c + delta
        else if maxExit then
            if areaMax < c + outOffset then
                c
            else
                c + delta
        else
            c
