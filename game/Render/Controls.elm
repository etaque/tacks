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
  "Next gate in " ++ (show d) ++ "m" |> baseText |> centered |> toForm

renderGateHint : Gate -> (Float,Float) -> Point -> Float -> Maybe Form
renderGateHint gate (w,h) (cx,cy) timer =
  let (left,right) = getGateMarks gate
      c = 5
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

renderWindWheel : Wind -> Player -> (Float,Float) -> Form
renderWindWheel wind player (w,h) =
  let r = 25 + wind.speed * 0.5
      c = circle r |> outlined (solid white)
      windOriginRadians = toRadians wind.origin
      windMarker = polygon [(0,4),(-4,-4),(4,-4)]
        |> filled white
        |> rotate (windOriginRadians + pi/2)
        |> move (fromPolar (r + 4, windOriginRadians))
      windOriginText = ((show (round wind.origin)) ++ "&deg;")
        |> baseText |> centered |> toForm
        |> move (0, r + 20)
      windSpeedText = ((show (round wind.speed)) ++ "kn")
        |> baseText |> centered |> toForm
      legend = "WIND" |> baseText |> centered |> toForm |> move (0, -50)

  in  group [c, windMarker, windOriginText, windSpeedText, legend] |> move (w/2 - 50, (h/2 - 80)) |> alpha 0.8

renderControls : GameState -> (Float,Float) -> Form
renderControls ({wind,player,opponents,course,now,countdown,center} as gameState) dims =
  let justForms =
        [ renderWindWheel wind player dims
        ]
      downwindHint = if (player.nextGate == Just "DownwindGate")
        then renderGateHint course.downwind dims center now
        else Nothing
      upwindHint = if (player.nextGate == Just "UpwindGate")
        then renderGateHint course.upwind dims center now
        else Nothing
      maybeForms =
        [ downwindHint
        , upwindHint
        ]
  in  group (justForms ++ (compact maybeForms))



