module Render.Course where

import Render.Utils (..)
import Core (..)
import Geo (..)
import Game (..)
import String
import Text

import Maybe (maybe)

gateLineOpacity : Float -> Float
gateLineOpacity timer = 0.5 + 0.5 * cos (timer * 0.005)

renderStartLine : Gate -> Float -> Bool -> Time -> Form
renderStartLine gate markRadius started timer =
  let lineStyle = if started
        then { defaultLine | width <- 2, color <- green, dashing <- [3,3] }
        else { defaultLine | width <- 2, color <- white }
      a = if started then gateLineOpacity timer else 0.5
      line = segment left right |> traced lineStyle |> alpha a
      (left,right) = getGateMarks gate
      marks = map (\g -> circle markRadius |> filled colors.gateMark |> move g) [left, right]
  in  group (line :: marks)

renderGate : Gate -> Float -> Float -> Bool -> Form
renderGate gate markRadius timer isNext =
  let (left,right) = getGateMarks gate
      lineStyle = if isNext
        then { defaultLine | width <- 2, color <- green, dashing <- [3,3] }
        else solid colors.seaBlue
      line = segment left right |> traced lineStyle |> alpha (gateLineOpacity timer)
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
  in rect w h |> outlined { defaultLine | width <- 2, color <- white, cap <- Round, join <- Smooth }
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

renderLaylines : GameState -> PlayerState -> Form
renderLaylines {wind,course} playerState =
  case playerState.nextGate of
    Just "UpwindGate"   -> renderGateLaylines playerState.upwindVmg wind.origin course.upwind
    Just "DownwindGate" -> renderGateLaylines playerState.downwindVmg wind.origin course.downwind
    _                   -> emptyForm

renderDownwindOrStartLine : GameState -> Form
renderDownwindOrStartLine ({playerState,course,now,countdown} as gameState) =
  if maybe False (\ps -> isEmpty ps.crossedGates) playerState
    then renderStartLine course.downwind course.markRadius (isStarted countdown) now
    else renderGate course.downwind course.markRadius now (maybe False (\ps -> ps.nextGate == Just "DownwindGate") playerState)

renderUpwind : GameState -> Form
renderUpwind ({playerState,course,now} as gameState) =
  renderGate course.upwind course.markRadius now (maybe False (\ps -> ps.nextGate == Just "UpwindGate") playerState)

renderCourse : GameState -> Form
renderCourse ({playerState,opponents,course,now,center} as gameState) =
  let forms =
        [ renderBounds gameState.course.area
        , maybe (toForm empty) (renderLaylines gameState) playerState
        , renderIslands gameState
        , renderDownwindOrStartLine gameState
        , renderUpwind gameState
        , renderGusts gameState.wind
        ]
  in  group forms |> move (neg center)

