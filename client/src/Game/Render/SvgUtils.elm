module Game.Render.SvgUtils where

import Models exposing (..)

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
