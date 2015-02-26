module Render.Controls where

import Render.Utils (..)
import Core (..)
import Geo (..)
import Game (..)

import String
import Text
import Maybe
import Graphics.Collage (..)

gateHintLabel: Int -> Form
gateHintLabel d =
  (toString d) ++ "m" |> baseText |> Text.centered |> toForm


gateHintTriangle : Float -> Bool -> Path
gateHintTriangle s isUpward =
  if isUpward then
    polygon [(0, 0), (-s, -s * 1.5), (s, -s * 1.5)]
  else
    polygon [(0, 0), (-s, s * 1.5), (s, s * 1.5)]

topHint : Path
topHint = gateHintTriangle 5 True

bottomHint : Path
bottomHint = gateHintTriangle 5 False

renderGateHint : Gate -> (Float,Float) -> Point -> Float -> Maybe Form
renderGateHint gate (w,h) (cx,cy) timer =
  let
    (left,right) = getGateMarks gate
    c = 3
    isOver = cy + h/2 + c < gate.y
    isUnder = cy - h/2 - c > gate.y
    markStyle = filled colors.orange
    lineStyle = { defaultLine | width <- 2, color <- colors.green, dashing <- [3,3] }
    a = 1 + 0.5 * cos (timer * 0.005)
    distance isOver = round (abs (gate.y + (if isOver then -h else h)/2 - cy) / 2)
    side = if | isOver    -> h/2
              | isUnder   -> -h/2
              | otherwise -> 0
  in
    if isOver || isUnder then
      let
        left = (-cx - (gate.width / 2), side)
        right = (-cx + (gate.width / 2), side)
        triangle = (if side > 0 then topHint else bottomHint) |> filled colors.orange |> alpha a
        leftMark = triangle |> move left
        rightMark = triangle |> move right
        line = segment left right |> traced lineStyle |> alpha a
        textY = if (side > 0) then -c else c
        d = distance (side > 0) |> gateHintLabel |> move (-cx, side + textY * 4) |> alpha 0.5
      in
        Just <| group [line, leftMark, rightMark, d]
    else
      Nothing

renderControls : GameState -> (Int,Int) -> Form
renderControls ({playerState,wind,opponents,course,now,center} as gameState) intDims =
  let dims = floatify intDims
      downwindHint = if (playerState.nextGate == Just DownwindGate)
        then renderGateHint course.downwind dims center now
        else Nothing
      upwindHint = if (playerState.nextGate == Just UpwindGate)
        then renderGateHint course.upwind dims center now
        else Nothing
  in  group (compact [downwindHint, upwindHint])



