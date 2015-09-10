module Game.RenderSvg.Dashboard where

import Game.Models exposing (..)
import Game.Core exposing (..)
import Models exposing (..)

import Game.Render.SvgUtils exposing (..)
import Game.Render.Utils exposing (..)
import Game.RenderSvg.Gates exposing (..)

import String
import List exposing (..)
import Maybe as M

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)


renderDashboard : (Int,Int) -> GameState -> Svg
renderDashboard (w,h) gameState =
  g [ ]
    [ text'
        [ textAnchor "middle"
        , x (toString (w // 2))
        , y (toString (h - 50))
        , fontSize "32px"
        , opacity "0.8"
        ]
        [ text (getTimer gameState) ]
    , g [ transform (translatePoint (toFloat w / 2, 30)) ]
        [ renderWindGauge h gameState.wind ]
    ]

getTimer : GameState -> String
getTimer {startTime, now, playerState} =
  case startTime of
    Just t ->
      let
        timer =
          if isNothing playerState.nextGate then
            M.withDefault 0 (head playerState.crossedGates)
          else
            t - now
      in
        formatTimer timer (isNothing playerState.nextGate)
    Nothing -> "start pending"


windGaugeCy = 500

renderWindGauge : Int -> Wind -> Svg
renderWindGauge h wind =
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

