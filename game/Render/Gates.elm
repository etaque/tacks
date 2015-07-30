module Render.Gates where

import Render.Utils exposing (..)
import Core exposing (..)
import Geo exposing (..)
import Game exposing (..)

import List exposing (..)
import Graphics.Collage exposing (..)
import Color exposing (white,black)
import Time exposing (Time)


type GateLocation = Upwind | Downwind


arcShape : Float -> Int -> Int -> Int -> Shape
arcShape r start length way =
  let
    steps = [0..(length // 10)]
    realSteps = map (\s -> toFloat (start + s * 10 * -way)) steps
    radSteps = map toRadians realSteps
  in
    map (\t -> fromPolar (r, t)) radSteps


clockwiseArrowTip : Float -> Shape
clockwiseArrowTip l =
  [(-l,l), (0,0), (-l,-l)]


counterClockwiseArrowTip : Float -> Shape
counterClockwiseArrowTip l =
  [(l,l), (0,0), (l,-l)]


nextLineStyle : LineStyle
nextLineStyle = { defaultLine | width <- 2, color <- colors.green, dashing <- [3,3] }


arrowLineStyle : LineStyle
arrowLineStyle = { defaultLine | width <- 2, color <- white, cap <- Round, join <- Smooth }


renderAroundArrow : Int -> Bool -> Float -> Form
renderAroundArrow headAngle clockwise timer =
  let
    r = markRadius * 4
    slidingAngle = 135
    arcAngle = 60
    way = if clockwise then 1 else -1
    timedAngle = floatMod (timer / 15) slidingAngle
    currentSlidingAngle = ((round timedAngle) - slidingAngle) * way
    arc = path (arcShape r (headAngle + currentSlidingAngle) arcAngle way)
      |> traced arrowLineStyle
    arrowRad = toRadians <| toFloat <| currentSlidingAngle + headAngle
    arrowTip = if clockwise then clockwiseArrowTip else counterClockwiseArrowTip
    arrow = path (arrowTip markRadius)
      |> traced arrowLineStyle
      |> rotate (arrowRad - pi/2)
      |> move (fromPolar (r, arrowRad))
  in
    group [arc, arrow]
      |> alpha (timedAngle / (toFloat slidingAngle) * 0.2)


aroundLeftUpwind = renderAroundArrow -45 False
aroundRightUpwind = renderAroundArrow 45 True
aroundLeftDownwind = renderAroundArrow 225 True
aroundRightDownwind = renderAroundArrow 135 False


renderStraightArrow : Bool -> Float -> Form
renderStraightArrow bottomUp timer =
  let
    lineLength = markRadius * 4
    l = markRadius
    way = if bottomUp then 1 else -1
    bodyShape = if bottomUp
      then [(0, -lineLength), (0,0)]
      else [(0, 0), (0, lineLength)]
    body = path bodyShape
      |> traced arrowLineStyle
    tipShape = if bottomUp
      then [(-l,-l), (0,0), (l,-l)]
      else [(-l,l), (0,0), (l,l)]
    tip = path tipShape
      |> traced arrowLineStyle
    arrowY = floatMod (timer * 0.02) 30
  in
    group [body, tip]
      |> move (0, arrowY * way)
      |> alpha ((arrowY * way) / 30 * 0.2)


gateLineOpacity : Float -> Float
gateLineOpacity timer = 0.7 + 0.3 * cos (timer * 0.005)


renderGateMark : Point -> Form
renderGateMark position =
  let
    inner = circle markRadius |> filled colors.orange
    outer = circle markRadius |> outlined (solid white)
  in
    group [inner, outer] |> move position


renderGateMarks : Gate -> Form
renderGateMarks gate =
  let
    (left,right) = getGateMarks gate
  in
    group <| map renderGateMark [left, right]


renderGateLine : Gate -> LineStyle -> Form
renderGateLine gate lineStyle =
  let (left,right) = getGateMarks gate
  in  segment left right |> traced lineStyle


renderGateHelpers : Gate -> GateLocation -> Float -> Form
renderGateHelpers gate gateLoc timer =
  let (left,right) = getGateMarks gate
      (leftHelper,rightHelper) = case gateLoc of
        Upwind   -> (aroundLeftUpwind timer, aroundRightUpwind timer)
        Downwind -> (aroundLeftDownwind timer, aroundRightDownwind timer)
  in  group [move left leftHelper, move right rightHelper]


renderStartLine : Gate -> Bool -> Time -> Form
renderStartLine gate started timer =
  let lineStyle = if started
        then nextLineStyle
        else { defaultLine | width <- 2, color <- colors.orange }
      a = if started then gateLineOpacity timer else 1
      line = renderGateLine gate lineStyle |> alpha a
      marks = renderGateMarks gate
      helper = if started
        then renderStraightArrow True timer |> move (0, gate.y - markRadius * 3)
        else emptyForm
  in  group [helper, line, marks]


renderGate : Gate -> Float -> Bool -> GateLocation -> Form
renderGate gate timer isNext gateType =
  let
    a = gateLineOpacity timer
    line = if isNext then renderGateLine gate nextLineStyle |> alpha a else emptyForm
    marks = renderGateMarks gate
    helpers = if isNext then renderGateHelpers gate gateType timer else emptyForm
  in
    group [line, marks, helpers]


renderFinishLine : Gate -> Time -> Form
renderFinishLine gate timer =
  let
    a = gateLineOpacity timer
    line = renderGateLine gate nextLineStyle |> alpha a
    marks = renderGateMarks gate
    helper = renderStraightArrow False timer
      |> move (0, gate.y + markRadius * 3)
      |> alpha (a * 0.5)
  in
    group [helper, line, marks]


renderGateLaylines : Vmg -> Float -> RaceArea -> Gate -> Form
renderGateLaylines vmg windOrigin area gate =
  let
    (w, h) = areaDims area
    lineLength = w / 2
    vmgRad = toRadians vmg.angle
    (leftMark,rightMark) = getGateMarks gate
    windAngleRad = toRadians windOrigin
    leftLineEnd = add leftMark (fromPolar (lineLength, windAngleRad + vmgRad + pi/2))
    rightLineEnd = add rightMark (fromPolar (lineLength, windAngleRad - vmgRad - pi/2))
    drawLine (p1,p2) = segment p1 p2 |> traced (dotted white)
  in
    group (map drawLine [(leftMark, leftLineEnd), (rightMark, rightLineEnd)]) |> alpha 0.3

