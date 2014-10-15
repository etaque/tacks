module Render.Course where

import Render.Utils (..)
import Core (..)
import Geo (..)
import Game (..)
import String
import Text

renderStartLine : Gate -> Float -> Bool -> Time -> Form
renderStartLine gate markRadius started timer =
  let lineStyle = if started then dotted green else solid orange
      line = segment left right |> traced lineStyle |> alpha a
      (left,right) = getGateMarks gate
      a = if started then 0.5 + 0.5 * cos (timer * 0.005) else 1
      marks = map (\g -> circle markRadius |> filled colors.gateMark |> move g) [left, right]
  in  group (line :: marks)

renderGate : Gate -> Float -> Bool -> Form
renderGate gate markRadius isNext =
  let (left,right) = getGateMarks gate
      lineStyle = if isNext
        then traced (dotted colors.gateLine)
        else traced (solid colors.seaBlue)
      line = segment left right |> lineStyle
      leftMark = circle markRadius |> filled colors.gateMark |> move left
      rightMark = circle markRadius |> filled colors.gateMark |> move right
  in  group [line, leftMark, rightMark]

renderBounds : RaceArea -> Form
renderBounds area =
  let {rightTop,leftBottom} = area
      w = fst rightTop - fst leftBottom
      h = snd rightTop - snd leftBottom
      cw = (fst rightTop + fst leftBottom) / 2
      ch = (snd rightTop + snd leftBottom) / 2
  in rect w h |> outlined (dashed white)
              |> alpha 0.3
              |> move (cw, ch)

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

renderGateLaylines : Vmg -> Float -> Gate -> Form
renderGateLaylines vmg windOrigin gate =
  let vmgRad = toRadians vmg.angle
      (leftMark,rightMark) = getGateMarks gate
      windAngleRad = toRadians windOrigin
      leftLineEnd = add leftMark (fromPolar (1000, windAngleRad + vmgRad + pi/2))
      rightLineEnd = add rightMark (fromPolar (1000, windAngleRad - vmgRad - pi/2))
      drawLine (p1,p2) = segment p1 p2 |> traced (solid white)
  in  group (map drawLine [(leftMark, leftLineEnd), (rightMark, rightLineEnd)]) |> alpha 0.3

renderLaylines : GameState -> Form
renderLaylines {playerState,wind,course} =
  case playerState.nextGate of
    Just "UpwindGate"   -> renderGateLaylines playerState.upwindVmg wind.origin course.upwind
    Just "DownwindGate" -> renderGateLaylines playerState.downwindVmg wind.origin course.downwind
    _                   -> emptyForm

renderCourse : GameState -> Form
renderCourse ({playerState,opponents,course,now,center} as gameState) =
  let downwindOrStartLine = if isEmpty playerState.crossedGates
        then renderStartLine course.downwind course.markRadius (isStarted gameState.countdown) now
        else renderGate course.downwind course.markRadius (playerState.nextGate == Just "DownwindGate")
      forms =
        [ renderBounds gameState.course.area
        , renderLaylines gameState
        , renderIslands gameState
        , downwindOrStartLine
        , renderGate course.upwind course.markRadius (playerState.nextGate == Just "UpwindGate")
        , renderGusts gameState.wind
        ]
  in  group forms |> move (neg center)

