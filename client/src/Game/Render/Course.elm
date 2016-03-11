module Game.Render.Course (..) where

import Constants
import Game.Models exposing (..)
import Model.Shared exposing (..)
import Hexagons
import Game.Render.Gates exposing (..)
import Game.Render.Tiles exposing (..)
import Dict
import Svg exposing (..)
import Svg.Attributes exposing (..)


renderCourse : GameState -> Svg
renderCourse ({ playerState, course, gusts, timers, wind } as gameState) =
  g
    [ class "course" ]
    [ lazyRenderTiles course.grid
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
      [ points verticesPoints
      , fill color
        -- , stroke color
        -- , strokeWidth "0.5"
      , opacity (toString a)
      , transform ("translate(" ++ toString x ++ ", " ++ toString y ++ ")")
      ]
      []


renderGates : PlayerState -> Course -> Float -> Bool -> Svg
renderGates playerState course now started =
  -- TODO
  g [ class "gates" ] []



-- renderGusts : Wind -> Svg
-- renderGusts wind =
--   g [ class "circle-gusts" ] (List.map renderGust wind.gusts)
-- renderGust : Gust -> Svg
-- renderGust gust =
--   let
--     a = 0.3 * (abs gust.speed) / 10
--     color = if gust.speed > 0 then "black" else "white"
--   in
--     circle
--       [ r (toString gust.radius)
--       , fill color
--       , fillOpacity (toString a)
--       , transform (translatePoint gust.position)
--       ] []
