module Game.RenderSvg.Course where

import Game.Models exposing (..)
import Models exposing (..)
import Game.Grid as Grid

import Game.Render.SvgUtils exposing (..)
import Game.Render.Utils exposing (..)
import Game.RenderSvg.Gates exposing (..)
import Game.RenderSvg.Tiles exposing (..)

import String
import Dict

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)

import Debug


renderCourse : GameState -> Svg
renderCourse ({playerState,course,gusts,timers,wind} as gameState) =
  g [ ]
    [ lazyRenderTiles course.grid
    , renderTiledGusts gusts
    -- , renderGusts wind
    , renderDownwind playerState course timers.now (isStarted gameState)
    , renderUpwind playerState course timers.now
    ]


renderTiledGusts : TiledGusts -> Svg
renderTiledGusts {gusts} =
  g [] (List.map renderTiledGust gusts)

renderTiledGust : TiledGust -> Svg
renderTiledGust {tiles} =
  tiles
    |> Dict.toList
    |> List.map renderGustTile
    |> g []

renderGustTile : (Coords, GustTile) -> Svg
renderGustTile (coords, {angle, speed}) =
  let
    (x,y) = Grid.hexCoordsToPoint coords
    a = 0.3 * (abs speed) / 10
    color = if speed > 0 then "black" else "white"
  in
    polygon
      [ points verticesPoints
      , fill color
      , opacity (toString a)
      , transform ("translate(" ++ toString x ++ ", " ++ toString y ++ ")")
      ]
      []


renderGusts : Wind -> Svg
renderGusts wind =
  g [] (List.map renderGust wind.gusts)

renderGust : Gust -> Svg
renderGust gust =
  let
    a = 0.3 * (abs gust.speed) / 10
    color = if gust.speed > 0 then "black" else "white"
  in
    circle
      [ r (toString gust.radius)
      , fill color
      , fillOpacity (toString a)
      , transform (translatePoint gust.position)
      ] []


