module Render.Controls where

import Render.Utils (..)
import Core (..)
import Geo (..)
import Game (..)
import String
import Text
import Maybe

gateHintLabel: Int -> Form
gateHintLabel d =
  (show d) ++ "m" |> baseText |> centered |> toForm

renderGateHint : Gate -> (Float,Float) -> Point -> Float -> Maybe Form
renderGateHint gate (w,h) (cx,cy) timer =
  let (left,right) = getGateMarks gate
      c = 3
      isOver = cy + h/2 + c < gate.y
      isUnder = cy - h/2 - c > gate.y
      markStyle = filled orange
      a = 1 + 0.5 * cos (timer * 0.005)
      distance isOver = round (abs (gate.y + (if isOver then -h else h)/2 - cy) / 2)
      side = if | isOver      -> h/2
                | isUnder     -> -h/2
                | otherwise -> 0
  in  if isOver || isUnder then Just <|
        let ml = triangle c (side > 0) |> markStyle |> move (-cx - (gate.width / 2), side)
            mr = triangle c (side > 0) |> markStyle |> move (-cx + (gate.width / 2), side)
            textY = if (side > 0) then -c else c
            d = distance (side > 0) |> gateHintLabel |> move (-cx, side + textY * 4) |> alpha a
        in  group [ml, mr, d]
      else
        Nothing

renderControls : GameState -> (Int,Int) -> PlayerState -> Form
renderControls ({wind,opponents,course,now,countdown,center} as gameState) intDims playerState =
  let dims = floatify intDims
      downwindHint = if (playerState.nextGate == Just "DownwindGate")
        then renderGateHint course.downwind dims center now
        else Nothing
      upwindHint = if (playerState.nextGate == Just "UpwindGate")
        then renderGateHint course.upwind dims center now
        else Nothing
  in  group (compact [downwindHint, upwindHint])



