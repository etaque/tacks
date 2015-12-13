module Game.Render.Tiles where

import Constants exposing (colors)

import Models exposing (..)

import Game.Grid as Grid exposing (getTilesList)

import Hexagons

import String
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)


lazyRenderTiles : Grid -> Svg
lazyRenderTiles grid =
  lazy renderTiles grid

renderTiles : Grid -> Svg
renderTiles grid =
  let
    tiles = List.map renderTile (getTilesList grid)
  in
    g [ ] tiles

renderTile : Tile -> Svg
renderTile {kind, coords} =
  let
    (x,y) = Hexagons.axialToPoint Grid.hexRadius coords
    color = tileKindColor kind
  in
    polygon
      [ points verticesPoints
      , fill color
      , stroke color
      , strokeWidth "1"
      , transform ("translate(" ++ toString x ++ ", " ++ toString y ++ ")")
      ]
      []

tileKindColor : TileKind -> String
tileKindColor kind =
  case kind of
    Water -> colors.water
    Grass -> colors.grass
    Rock -> colors.rock

verticesPoints : String
verticesPoints =
  toSvgPoints vertices

vertices : List Point
vertices =
  let
    (w,h) = Grid.hexDims
    w2 = w / 2
    h2 = h / 2
    h4 = h / 4
  in
    [ (-w2, -h4)
    , (0, -h2)
    , (w2, -h4)
    , (w2, h4)
    , (0, h2)
    , (-w2, h4)
    ]

toSvgPoints : List Point -> String
toSvgPoints points =
  points
    |> List.map (\(x, y) -> toString x ++ "," ++ toString y)
    |> String.join " "

