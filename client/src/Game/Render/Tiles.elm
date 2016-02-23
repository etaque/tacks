module Game.Render.Tiles where

import String
import Color
import Color.Mixing as Mix
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)

import Hexagons
import Hexagons.Grid as Grid

import Constants exposing (..)
import Model.Shared exposing (..)


lazyRenderTiles : Grid -> Svg
lazyRenderTiles grid =
  lazy renderTiles grid

renderTiles : Grid -> Svg
renderTiles grid =
  let
    tiles = List.map renderTile (Grid.list grid)
  in
    g [ ] tiles

renderTile : Tile -> Svg
renderTile {content, coords} =
  let
    (x,y) = Hexagons.axialToPoint hexRadius coords
    color = tileKindColor content coords
  in
    polygon
      [ points verticesPoints
      , fill color
      , stroke color
      , strokeWidth "1"
      , transform ("translate(" ++ toString x ++ ", " ++ toString y ++ ")")
      ]
      []

tileKindColor : TileKind -> Coords -> String
tileKindColor kind (x,y) =
  case kind of
    Grass -> colors.grass
    Rock -> colors.rock
    Water ->
      let
        pseudoRandom = (toFloat (x*y + x*2 + y*2)) * pi |> round
        factor = toFloat (pseudoRandom % 20 - 10) / 200
        {red, green, blue} = seaBlue
          |> Mix.spin factor
          |> Color.toRgb
        colors = List.map toString [ red, green, blue ] |> String.join(",")
      in
        "rgb(" ++ colors ++ ")"

verticesPoints : String
verticesPoints =
  toSvgPoints vertices

vertices : List Point
vertices =
  let
    (w,h) = Hexagons.dims Constants.hexRadius
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

