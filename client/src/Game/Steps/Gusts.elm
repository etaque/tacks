module Game.Steps.Gusts where

import Models exposing (..)
import Game.Models exposing (..)

import Game.Grid as Grid exposing (..)
import Game.Geo as Geo

import Dict


interval = 500


gustsStep : GameState -> GameState
gustsStep ({timers, wind, gusts} as gameState) =
  if gusts.genTime + interval < timers.now then
    { gameState | gusts <- genTiledGusts timers.now wind }
  else
    gameState


genTiledGusts : Float -> Wind -> TiledGusts
genTiledGusts now {gusts} =
  { genTime = now
  , gusts = List.map genTiledGust gusts
  }


genTiledGust : Gust -> TiledGust
genTiledGust ({position, angle, speed, radius} as gust) =
  let
    centerTile = pointToHexCoords position
    southTile = pointToHexCoords (Geo.add position (0, -radius))

    distance = hexDistance centerTile southTile
    coordsList = hexRange centerTile distance

    tiles = coordsList
      |> List.filterMap (genGustTile gust)
      |> Dict.fromList
  in
    TiledGust position radius tiles


genGustTile : Gust -> Coords -> Maybe (Coords, GustTile)
genGustTile {position, angle, speed, radius} coords =
  let
    distance = Geo.distance position (hexCoordsToPoint coords)
  in
    if distance <= radius then
      let
        fromEdge = radius - distance
        factor = min (fromEdge / (radius * 0.2)) 1
        gustTile = GustTile (angle * factor) (speed * factor)
      in
        Just (coords, gustTile)
    else
      Nothing
