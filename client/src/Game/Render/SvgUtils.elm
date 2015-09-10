module Game.Render.SvgUtils where

import Models exposing (..)
import Game.Core as Core exposing (toRadians)
import Game.Geo as Geo exposing (rotateDeg)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)

import String
import Color exposing (Color)


translate : number -> number -> String
translate x y =
  "translate(" ++ (toString x) ++ ", " ++ (toString y) ++ ")"

translatePoint : Point -> String
translatePoint (x, y) =
  translate x y

rotate_ : number -> number -> number -> String
rotate_ a cx cy =
  "rotate(" ++ toString a ++ ", " ++ toString cx ++ ", " ++ toString cy ++ ")"

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
  List.map (\(x, y) -> toString x ++ "," ++ toString y) pointsList
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

type alias ArcDef =
  { center : Point
  , radius : Float
  , fromAngle : Float
  , toAngle : Float
  }

arc : List Attribute -> ArcDef -> Svg
arc attrs {center, radius, fromAngle, toAngle} =
  let
    (x1, y1) = Geo.sub (rotateDeg fromAngle radius) center
    (x2, y2) = Geo.sub (rotateDeg toAngle radius) center
    moveCmd = buildCmd "M" [ x1, y1 ]
    arcCmd = buildCmd "A" [ radius, radius, 0, 0, 0, x2, y2]
    cmd = moveCmd ++ arcCmd
  in
    Svg.path
      ((d cmd) :: attrs)
      []

buildCmd : String -> List number -> String
buildCmd cmd numbers =
  cmd :: (List.map toString numbers)
    |> String.join " "

empty : Svg
empty =
  g [ ] [ ]
