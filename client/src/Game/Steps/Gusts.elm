module Game.Steps.Gusts where

import Models exposing (..)
import Game.Models exposing (..)

import Game.Grid as Grid exposing (..)
import Game.Geo as Geo
import Hexagons

import Dict


interval = 500


gustsStep : GameState -> GameState
gustsStep ({timers, wind, gusts, course} as gameState) =
  if gusts.genTime + interval < timers.now then
    { gameState | gusts = genTiledGusts course.grid timers.now wind }
  else
    gameState


genTiledGusts : Grid -> Float -> Wind -> TiledGusts
genTiledGusts grid now {gusts} =
  { genTime = now
  , gusts = List.map (genTiledGust grid) gusts
  }


genTiledGust : Grid -> Gust -> TiledGust
genTiledGust grid ({position, angle, speed, radius} as gust) =
  let
    centerTile = Hexagons.pointToAxial hexRadius position
    southTile = Hexagons.pointToAxial hexRadius (Geo.add position (0, -radius))

    distance = Hexagons.axialDistance centerTile southTile
    coordsList = Hexagons.axialRange centerTile distance

    tiles = coordsList
      |> List.filterMap (genGustTile grid gust)
      |> Dict.fromList
  in
    TiledGust position radius tiles


genGustTile : Grid -> Gust -> Coords -> Maybe (Coords, GustTile)
genGustTile grid {position, angle, speed, radius} coords =
  let
    distance = Geo.distance position (Hexagons.axialToPoint hexRadius coords)
  in
    if distance <= radius then
      let
        fromEdge = radius - distance
        factor = min (fromEdge / (radius * 0.2)) 1
        gustTile = GustTile (angle * factor) (speed * factor)
      in
        if getTile grid coords == Just Water then
          Just (coords, gustTile)
        else
          Nothing
    else
      Nothing
