module Game.Render.Dashboard.VmgBar where

import Game.Models exposing (..)
import Game.Core exposing (..)
import Models exposing (..)

import Game.Render.SvgUtils exposing (..)
import Game.Render.Gates exposing (..)

import String
import List exposing (..)
import Maybe as M

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)

barWidth = 150
barHeight = 5

render : PlayerState -> Svg
render playerState =
  let
    -- bar = rect
    --   [ width (toString barWidth)
    --   , height (toString barHeight)
    --   , opacity "0"
    --   , stroke "black"
    --   , strokeWidth "1"
    --   , strokeOpacity "1"
    --   , fillOpacity "0"
    --   ]
    --   []
    coef = vmgCoef playerState
    contour = g [ stroke "black" ]
      [ segment [ stroke "black" ] ((0, 0), (barWidth, 0))
      , segment [ stroke "black" ] ((0, 0), (0, barHeight))
      , segment [ stroke "black" ] ((barWidth, 0), (barWidth, barHeight))
      , segment [ stroke "black" ] ((-5, barHeight), (barWidth + 5, barHeight))
      ]
    bar = rect
      [ width (toString (barWidth * coef))
      , height (toString barHeight)
      -- , fill "url(#midBlack)"
      , fill "black"
      , opacity "1"
      ]
      []
    label = text'
      [ textAnchor "middle"
      , x (toString (barWidth * coef))
      , y (toString (barHeight + 15))
      , fontSize "12px"
      ]
      [ text <| toString (floor (coef * 100)) ++ "%" ]
  in
    g [ opacity "0.5" ]
      [ contour
      , bar
      , label
      ]


vmgCoef : PlayerState -> Float
vmgCoef {windAngle,velocity,vmgValue,downwindVmg,upwindVmg} =
  let
    theoricVmgValue =
      if (abs windAngle) < 90
      then upwindVmg.value
      else downwindVmg.value

    boundedVmgValue =
      if vmgValue > theoricVmgValue
      then theoricVmgValue
      else
        if vmgValue < 0
        then 0
        else vmgValue
  in
    boundedVmgValue / theoricVmgValue

