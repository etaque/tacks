module Game.Render.Course (..) where

import Constants
import Game.Models exposing (..)
import Model.Shared exposing (..)
import Hexagons
import Game.Render.Gates as Gates
import Game.Render.Tiles as Tiles
import Dict
import Svg exposing (..)
import Svg.Attributes exposing (..)


renderCourse : GameState -> Svg
renderCourse ({ playerState, course, gusts, timers, wind } as gameState) =
  g
    [ class "course" ]
    [ Tiles.lazyRenderTiles course.grid
    , renderTiledGusts gusts
      -- , renderGusts wind
    , renderGates playerState course timers.now (isStarted gameState)
    ]


renderTiledGusts : TiledGusts -> Svg
renderTiledGusts { gusts } =
  g [ class "tiled-gusts" ] (List.map renderTiledGust gusts)


renderTiledGust : TiledGust -> Svg
renderTiledGust { tiles } =
  tiles
    |> Dict.toList
    |> List.map renderGustTile
    |> g [ class "tiled-gust" ]


renderGustTile : ( Coords, GustTile ) -> Svg
renderGustTile ( coords, { angle, speed } ) =
  let
    ( x, y ) =
      Hexagons.axialToPoint Constants.hexRadius coords

    a =
      0.3 * (abs speed) / 10

    color =
      if speed > 0 then
        "black"
      else
        "white"
  in
    polygon
      [ points Tiles.verticesPoints
      , fill color
      , opacity (toString a)
      , transform ("translate(" ++ toString x ++ ", " ++ toString y ++ ")")
      ]
      []


renderGates : PlayerState -> Course -> Float -> Bool -> Svg
renderGates { crossedGates } { start, gates } now started =
  start :: gates
    |> List.indexedMap (\i g -> Gates.render now started (i - List.length crossedGates) g)
    |> List.filterMap identity
    |> g [ class "gates" ]

