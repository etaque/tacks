module Render.Course where

import Render.Utils (..)
import Core (..)
import Geo (..)
import Game (..)
import String
import Text

import Maybe (maybe)

arcShape : Float -> Int -> Int -> Shape
arcShape r a b =
  let
    (a', b') = if a > b then (b,a) else (a,b)
    steps = map (\s -> toFloat (s * 10)) [(a' // 10)..(b' // 10)]
  in
    map (\t -> fromPolar (r, t)) (map toRadians steps)

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

renderAroundArrow : Int -> Int -> Bool -> Float -> Form
renderAroundArrow headAngle tailAngle clockwise markRadius =
  let
    r = markRadius * 4
    arc = path (arcShape r headAngle tailAngle)
      |> traced arrowLineStyle
    arrowRad = toRadians (toFloat headAngle)
    arrowTip = if clockwise then clockwiseArrowTip else counterClockwiseArrowTip
    arrow = path (arrowTip markRadius)
      |> traced arrowLineStyle
      |> rotate (arrowRad - pi/2)
      |> move (fromPolar (r, arrowRad))
  in
    group [arc, arrow]

aroundLeftUpwind = renderAroundArrow -90 120 False
aroundRightUpwind = renderAroundArrow 90 -120 True
aroundLeftDownwind = renderAroundArrow 300 60 True
aroundRightDownwind = renderAroundArrow 60 300 False

renderStraightArrow : Float -> Bool -> Form
renderStraightArrow markRadius bottomUp =
  let
    lineLength = toFloat (markRadius * 4)
    l = markRadius
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
  in
    group [body, tip]


gateLineOpacity : Float -> Float
gateLineOpacity timer = 0.7 + 0.3 * cos (timer * 0.005)

renderGateMark : Float -> Point -> Form
renderGateMark radius position =
  let
    inner = circle radius |> filled colors.orange
    outer = circle radius |> outlined (solid white)
  in
    group [inner, outer] |> move position

renderGateMarks : Gate -> Float -> Form
renderGateMarks gate markRadius =
  let
    (left,right) = getGateMarks gate
  in
    group <| map (renderGateMark markRadius) [left, right]

renderGateLine : Gate -> LineStyle -> Form
renderGateLine gate lineStyle =
  let (left,right) = getGateMarks gate
  in  segment left right |> traced lineStyle

data GateLocation = Upwind | Downwind

renderGateHelpers : Gate -> Float -> GateLocation -> Form
renderGateHelpers gate markRadius gateLoc =
  let (left,right) = getGateMarks gate
      (leftHelper,rightHelper) = case gateLoc of
        Upwind   -> (aroundLeftUpwind markRadius, aroundRightUpwind markRadius)
        Downwind -> (aroundLeftDownwind markRadius, aroundRightDownwind markRadius)
  in  group [move left leftHelper, move right rightHelper]


renderStartLine : Gate -> Float -> Bool -> Time -> Form
renderStartLine gate markRadius started timer =
  let lineStyle = if started
        then nextLineStyle
        else { defaultLine | width <- 2, color <- colors.orange }
      a = if started then gateLineOpacity timer else 1
      line = renderGateLine gate lineStyle |> alpha a
      marks = renderGateMarks gate markRadius
      helper = renderStraightArrow markRadius True
        |> move (0, gate.y - markRadius * 3)
        |> alpha (a * 0.5)
  in  group [helper, line, marks]

renderGate : Gate -> Float -> Float -> Bool -> GateLocation -> Form
renderGate gate markRadius timer isNext gateType =
  let
    a = gateLineOpacity timer
    line = if isNext then renderGateLine gate nextLineStyle |> alpha a else emptyForm
    marks = renderGateMarks gate markRadius
    helpers = if isNext then renderGateHelpers gate markRadius gateType |> alpha (a * 0.3) else emptyForm
  in
    group [line, marks, helpers]

renderFinishLine : Gate -> Float -> Time -> Form
renderFinishLine gate markRadius timer =
  let
    a = gateLineOpacity timer
    line = renderGateLine gate nextLineStyle |> alpha a
    marks = renderGateMarks gate markRadius
    helper = renderStraightArrow markRadius False
      |> move (0, gate.y + markRadius * 3)
      |> alpha (a * 0.5)
  in
    group [helper, line, marks]

renderBounds : RaceArea -> Form
renderBounds area =
  let
    (w,h) = areaDims area
    (cw,ch) = areaCenters area
    fill = rect w h
      |> filled colors.seaBlue
    stroke = rect w h
      |> outlined { defaultLine | width <- 1, color <- white, cap <- Round, join <- Smooth }
      |> alpha 0.8
  in
    group [fill, stroke] |> move (cw, ch)

renderGust : Wind -> Gust -> Form
renderGust wind gust =
  let a = 0.3 * (abs gust.speed) / 10
      color = if gust.speed > 0 then black else white
  in  circle gust.radius |> filled color |> alpha a |> move gust.position

renderGusts : Wind -> Form
renderGusts wind =
  group <| map (renderGust wind) wind.gusts

renderIslands : GameState -> Form
renderIslands gameState =
  let renderIsland {location,radius} = circle radius |> filled colors.sand |> move location
  in  group <| map renderIsland gameState.course.islands

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

renderLaylines : GameState -> PlayerState -> Form
renderLaylines {wind,course} playerState =
  case playerState.nextGate of
    Just "UpwindGate"   -> renderGateLaylines playerState.upwindVmg wind.origin course.area course.upwind
    Just "DownwindGate" -> renderGateLaylines playerState.downwindVmg wind.origin course.area course.downwind
    _                   -> emptyForm

renderDownwind : GameState -> Form
renderDownwind ({playerState,course,now,countdown} as gameState) =
  let
    isFirstGate = maybe False (\ps -> isEmpty ps.crossedGates) playerState
    isLastGate = maybe False (\ps -> (length ps.crossedGates) == course.laps * 2) playerState
    isNext = maybe False (\ps -> ps.nextGate == Just "DownwindGate") playerState
  in
    if | isFirstGate -> renderStartLine course.downwind course.markRadius (isStarted countdown) now
       | isLastGate  -> renderFinishLine course.downwind course.markRadius now
       | otherwise   -> renderGate course.downwind course.markRadius now isNext Downwind

renderUpwind : GameState -> Form
renderUpwind ({playerState,course,now} as gameState) =
  let
    isNext = maybe False (\ps -> ps.nextGate == Just "UpwindGate") playerState
  in
    renderGate course.upwind course.markRadius now isNext Upwind

renderCourse : GameState -> Form
renderCourse ({playerState,opponents,course,now,center} as gameState) =
  let
    forms =
      [ renderBounds gameState.course.area
      , maybe (toForm empty) (renderLaylines gameState) playerState
      , renderIslands gameState
      , renderDownwind gameState
      , renderUpwind gameState
      , renderGusts gameState.wind
      ]
  in
    group forms |> move (neg center)

