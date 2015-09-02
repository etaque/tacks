module Game.Render.SvgUtils where

import Models exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)

import String
import Color exposing (Color)


translate : Float -> Float -> String
translate x y =
  "translate(" ++ (toString x) ++ ", " ++ (toString y) ++ ")"

translatePoint : Point -> String
translatePoint (x, y) =
  translate x y

colorToSvg : Color -> String
colorToSvg color =
  let
    {red, green, blue, alpha} = Color.toRgb color
    s = (List.map toString [red, green, blue]) ++ [toString alpha]
      |> String.join ","
  in
    "rgba(" ++ s ++ ")"

segment : List Attribute -> (Point, Point) -> Svg
segment attrs (p1, p2) =
  line (attrs ++ (lineCoords p1 p2)) [ ]


polygonPoints : List Point -> Attribute
polygonPoints pointsList =
  List.map (\(x, y) -> (toString x) ++ "," ++ (toString y)) pointsList
    |> String.join " "
    |> points

lineCoords : Point -> Point -> List Attribute
lineCoords p1 p2 =
  let
    x = fst >> toString
    y = snd >> toString
  in
    [ x1 (x p1)
    , y1 (y p1)
    , x2 (x p2)
    , y2 (y p2)
    ]

empty : Svg
empty =
  g [ ] [ ]
