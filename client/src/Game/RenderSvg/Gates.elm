module Game.RenderSvg.Gates where

import Game.Models exposing (..)
import Models exposing (..)

import Game.Render.SvgUtils exposing (..)
import Game.Render.Utils exposing (..)

import String
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)


renderDownwind : PlayerState -> Course -> Float -> Bool -> Svg
renderDownwind playerState course now started =
  let
    isFirstGate = List.isEmpty playerState.crossedGates
    isLastGate = List.length playerState.crossedGates == course.laps * 2
    isNext = playerState.nextGate == Just DownwindGate
  in
    if | isFirstGate -> renderStartLine course.downwind started now
       | isLastGate  -> renderFinishLine course.downwind now
       | otherwise   -> renderGate course.downwind now isNext DownwindGate


renderUpwind : PlayerState -> Course -> Float -> Svg
renderUpwind playerState course now =
  let
    isNext = playerState.nextGate == Just UpwindGate
  in
    renderGate course.upwind now isNext UpwindGate

renderStartLine : Gate -> Bool -> Float -> Svg
renderStartLine gate started timer =
  let
    marks = renderGateMarks gate
    lineStyle = if started
      then [ stroke (colorToSvg colors.green), strokeWidth "2" ]
      else [ stroke (colorToSvg colors.orange), strokeWidth "2" ]
    a = if started then gateLineOpacity timer else 1
    (left,right) = getGateMarks gate
    l = segment (opacity (toString a) :: lineStyle ) (getGateMarks gate)
  in
    g [ ] [ l, marks ]
  -- let lineStyle = if started
  --       then nextLineStyle
  --       else { defaultLine | width <- 2, color <- colors.orange }
  --     a = if started then gateLineOpacity timer else 1
  --     line = renderGateLine gate lineStyle |> alpha a
  --     marks = renderGateMarks gate
  --     helper = if started
  --       then renderStraightArrow True timer |> move (0, gate.y - markRadius * 3)
  --       else emptyForm
  -- in  group [helper, line, marks]

renderFinishLine : Gate -> Float -> Svg
renderFinishLine gate timer =
  let
    marks = renderGateMarks gate
  in
    g [ ] [ marks ]
  -- let
  --   a = gateLineOpacity timer
  --   line = renderGateLine gate nextLineStyle |> alpha a
  --   marks = renderGateMarks gate
  --   helper = renderStraightArrow False timer
  --     |> move (0, gate.y + markRadius * 3)
  --     |> alpha (a * 0.5)
  -- in
  --   group [helper, line, marks]

renderGate : Gate -> Float -> Bool -> GateLocation -> Svg
renderGate gate timer isNext gateLoc =
  let
    marks = renderGateMarks gate
  in
    g [ ] [ marks ]

renderGateMarks : Gate -> Svg
renderGateMarks gate =
  let
    (left, right) = getGateMarks gate
  in
    g [ ] (List.map renderGateMark [ left, right ])

renderGateMark : Point -> Svg
renderGateMark p =
  circle
    [ r (toString markRadius)
    , stroke (colorToSvg colors.orange)
    , strokeWidth "2"
    , fill "white"
    , transform (translatePoint p)
    ]
    [ ]

gateLineOpacity : Float -> Float
gateLineOpacity timer =
  0.7 + 0.3 * cos (timer * 0.005)











