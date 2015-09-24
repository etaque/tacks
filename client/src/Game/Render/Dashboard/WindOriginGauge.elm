module Game.Render.Dashboard.WindOriginGauge where

import Game.Models exposing (..)
import Game.Core exposing (..)
import Models exposing (..)

import Game.Render.SvgUtils exposing (..)
import Game.Render.Utils exposing (..)
import Game.Render.Gates exposing (..)

import String
import List exposing (..)
import Maybe as M

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)

windGaugeCy = 500

render : Int -> Wind -> Svg
render h wind =
  let
    cy = (toFloat h / 2)
  in
    g [ opacity "0.5"
      ]
      [ renderRuledArc
      , g [ transform <| rotate_ wind.origin 0 windGaugeCy ]
          [ renderWindArrow
          , renderWindOriginText wind.origin
          ]
      ]

renderWindArrow : Svg
renderWindArrow =
  Svg.path
    [ d "M 0,0 4,-15 0,-12 -4,-15 Z"
    , fill "black"
    ] []

renderWindOriginText : Float -> Svg
renderWindOriginText origin =
  text'
    [ textAnchor "middle"
    , x "0"
    , y "15"
    , fontSize "12px"
    ]
    [ text <| toString (round origin) ++ "°" ]


renderRuledArc : Svg
renderRuledArc =
  let
    tick l r = segment
      [ stroke "black", opacity "0.5", transform (rotate_ r 0 windGaugeCy) ]
      ((0, 0), (0, -l))
    smallTick = tick 5
    bigTick = tick 7.5
  in
    g [ ]
      [ renderWindArc
      , smallTick -15, bigTick -10, smallTick -5
      , bigTick 0
      , smallTick 5, bigTick 10, smallTick 15
      ]

renderWindArc : Svg
renderWindArc =
  arc
    [ stroke "black"
    , strokeWidth "1"
    , fillOpacity "0"
    ]
    { center = (0, 500)
    , radius = windGaugeCy
    , fromAngle = -17.5
    , toAngle = 17.5
    }
