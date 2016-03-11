module Game.Render.Gates (..) where

import Game.Models exposing (..)
import Model.Shared exposing (..)
import Constants exposing (colors)
import Game.Render.SvgUtils exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)


-- renderDownwind : PlayerState -> Course -> Float -> Bool -> Svg
-- renderDownwind playerState course now started =
--   case playerState.nextGate of
--     Just StartLine ->
--       if started then
--         renderOpenGate course.downwind now
--       else
--         renderClosedGate course.downwind now
--
--     Just DownwindGate ->
--       renderOpenGate course.downwind now
--
--     _ ->
--       renderClosedGate course.downwind now
--
--
-- renderUpwind : PlayerState -> Course -> Float -> Svg
-- renderUpwind playerState course now =
--   case playerState.nextGate of
--     Just UpwindGate ->
--       renderOpenGate course.upwind now
--
--     _ ->
--       renderClosedGate course.upwind now


renderOpenGate : Gate -> Float -> Svg
renderOpenGate gate timer =
  let
    lineStyle =
      [ stroke "white"
      , strokeWidth "2"
      , strokeDasharray "5,3"
      , opacity (toString (gateLineOpacity timer))
      ]
  in
    renderGate gate lineStyle colors.green


renderClosedGate : Gate -> Float -> Svg
renderClosedGate gate timer =
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
