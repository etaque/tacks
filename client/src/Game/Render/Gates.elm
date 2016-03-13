module Game.Render.Gates (..) where

import Game.Models exposing (..)
import Model.Shared exposing (..)
import Constants exposing (colors)
import Game.Render.SvgUtils exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)


render : Bool -> Float -> Gate -> Svg
render open timer gate =
  if open then
    renderOpenGate timer gate
  else
    renderClosedGate timer gate


renderOpenGate : Float -> Gate -> Svg
renderOpenGate timer gate =
  let
    lineStyle =
      [ stroke "white"
      , strokeWidth "2"
      , strokeDasharray "5,3"
      , opacity (toString (gateLineOpacity timer))
      ]
  in
    renderGate gate lineStyle colors.green


renderClosedGate : Float -> Gate -> Svg
renderClosedGate timer gate =
  let
    lineStyle =
      [ stroke "white"
      , strokeWidth "2"
      ]
  in
    renderGate gate lineStyle "black"


renderGate : Gate -> List Attribute -> String -> Svg
renderGate gate lineStyle color =
  let
    l =
      segment lineStyle (getGateMarks gate)

    marks =
      renderGateMarks color gate
  in
    g [] [ l, marks ]


renderGateMarks : String -> Gate -> Svg
renderGateMarks color gate =
  let
    ( a, b ) =
      getGateMarks gate
  in
    g [] (List.map (renderGateMark color) [ a, b ])


renderGateMark : String -> Point -> Svg
renderGateMark color p =
  circle
    [ r (toString markRadius)
    , stroke "white"
    , strokeWidth "2"
    , fill color
    , transform (translatePoint p)
    ]
    []


gateLineOpacity : Float -> Float
gateLineOpacity timer =
  0.7 + 0.3 * cos (timer * 0.005)
