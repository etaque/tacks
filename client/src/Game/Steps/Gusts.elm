module Game.Steps.Gusts exposing (..)

import Constants exposing (..)
import Model.Shared exposing (..)
import Game.Shared exposing (..)
import Game.Utils as Utils
import Hexagons
import Dict


interval : Float
interval =
    500


gustsStep : GameState -> GameState
gustsStep ({ timers, wind, gusts, course } as gameState) =
    if gusts.genTime + interval < timers.serverTime then
        { gameState | gusts = genTiledGusts course.grid timers.serverTime wind }
    else
        gameState


genTiledGusts : Grid -> Float -> Wind -> TiledGusts
genTiledGusts grid now { gusts } =
    { genTime = now
    , gusts = List.map (genTiledGust grid) gusts
    }


genTiledGust : Grid -> Gust -> TiledGust
genTiledGust grid ({ position, angle, speed, radius } as gust) =
    let
        centerTile =
            Hexagons.pointToAxial hexRadius position

        southTile =
            Hexagons.pointToAxial hexRadius (Utils.add position ( 0, -radius ))

        distance =
            Hexagons.axialDistance centerTile southTile

        coordsList =
            Hexagons.axialRange centerTile distance

        tiles =
            coordsList
                |> List.filterMap (genGustTile grid gust)
                |> Dict.fromList
    in
        TiledGust position radius tiles


genGustTile : Grid -> Gust -> Coords -> Maybe ( Coords, GustTile )
genGustTile grid { position, angle, speed, radius } coords =
    let
        distance =
            Utils.distance position (Hexagons.axialToPoint hexRadius coords)
    in
        if distance <= radius then
            let
                fromEdge =
                    radius - distance

                factor =
                    min (fromEdge / (radius * 0.2)) 1

                gustTile =
                    GustTile (angle * factor) (speed * factor)
            in
                if Dict.get coords grid == Just Water then
                    Just ( coords, gustTile )
                else
                    Nothing
        else
            Nothing
