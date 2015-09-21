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
genTiledGust {position, angle, speed, radius} =
  let
    centerTile = pointToHexCoords position
    southTile = pointToHexCoords (Geo.add position (0, -radius))

    distance = hexDistance centerTile southTile
    coordsList = hexRange centerTile distance

    tiles = coordsList
      |> List.filter (\c -> Geo.distance position (hexCoordsToPoint c) <= radius)
      |> List.map (\c -> (c, GustTile angle speed))
      |> Dict.fromList
  in
    TiledGust position radius tiles
