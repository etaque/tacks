module Game.RenderSvg.Players where

import Game.Models exposing (..)
import Models exposing (..)

import Game.Render.SvgUtils exposing (..)
import Game.Render.Utils exposing (..)

import String
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)


renderPlayerHull : Float -> Svg
renderPlayerHull heading =
  g
    [ transform (hullRotation heading) ]
    [ hull ]

hullRotation : Float -> String
hullRotation heading =
  let
    r = (180-heading)
  in
    "rotate(" ++ toString r ++ ")"

hull : Svg
hull =
  Svg.path
    [ d "m -3.6481527,10 c 0,0 -0.3441944,-4.017 -0.3441944,-7.0051 0,-3.9677 2.1760648,-9.5098 3.1453492,-11.8415 0.62518992,-1.5042 0.8739859,-1.4975 1.50907569,0 0.96588441,2.2813 3.33024631,7.8678 3.33024631,11.8388 l -0.3743939,7.0202 z"
    , fill "white"
    ] []
