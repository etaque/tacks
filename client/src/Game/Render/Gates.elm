module Game.Render.Gates exposing (..)

import Game.Models exposing (..)
import Model.Shared exposing (..)
import Constants exposing (colors)
import Game.Render.SvgUtils exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)


render : Float -> Bool -> Int -> Gate -> Maybe (Svg msg)
render timer started index gate =
  if index == 0 then
    if started then
      Just (renderOpenGate timer gate)
    else
      Just (renderStartGate timer gate)
  else if index == -1 || index == 1 then
    Just (renderClosedGate timer gate)
  else
    Nothing


renderOpenGate : Float -> Gate -> Svg msg
renderOpenGate timer gate =
  let
    lineStyle =
      [ stroke "white"
      , strokeWidth "2"
      , strokeDasharray "5,3"
      , opacity (toString (gateLineOpacity timer))
      ]
  in
    renderGate gate lineStyle 1 colors.green


renderStartGate : Float -> Gate -> Svg msg
renderStartGate timer gate =
  let
    lineStyle =
      [ stroke "white"
      , strokeWidth "2"
      ]
  in
    renderGate gate lineStyle 1 colors.green


renderClosedGate : Float -> Gate -> Svg msg
renderClosedGate timer gate =
  let
    lineStyle =
      [ stroke "white"
      , strokeWidth "2"
      ]
  in
    renderGate gate lineStyle 0.4 "black"


renderGate : Gate -> List (Attribute msg) -> Float -> String -> Svg msg
renderGate gate lineStyle op color =
  let
    l =
      segment lineStyle (getGateMarks gate)

    marks =
      renderGateMarks color gate
  in
    g [ opacity (toString op) ] [ l, marks ]


renderGateMarks : String -> Gate -> Svg msg
renderGateMarks color gate =
  let
    ( a, b ) =
      getGateMarks gate
  in
    g [] (List.map (renderGateMark color) [ a, b ])


renderGateMark : String -> Point -> Svg msg
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
