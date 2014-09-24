module Render.Controls where

import Render.Utils (..)
import Core (..)
import Geo (..)
import Game (..)
import String
import Text

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

renderLapsCount : (Float,Float) -> Course -> Player -> Form
renderLapsCount (w,h) course player =
  let count = minimum [(div ((length player.crossedGates) + 1) 2), course.laps]
      msg = "LAP " ++ (show count) ++ "/" ++ (show course.laps)
  in msg
      |> baseText
      |> leftAligned
      |> toForm
      |> move (-w / 2 + 50, h / 2 - 30)

--renderPolar : Player -> (Float,Float) -> Form
--renderPolar player (w,h) =
--  let
--    absWindAngle = abs player.windAngle
--    anglePoint a = fromPolar ((polarVelocity player.windSpeed a), toRadians a)
--    points = map anglePoint [0..180]
--    maxSpeed = 100
--    polar = path points |> traced (solid white)
--    yAxis = segment (0,(maxSpeed/2)) (0,-maxSpeed) |> traced (solid white) |> alpha 0.6
--    xAxis = segment (0,0) (maxSpeed,0) |> traced (solid white) |> alpha 0.6
--    playerPoint = anglePoint absWindAngle
--    playerMark = circle 2 |> filled red |> move playerPoint
--    playerSegment = segment (0,0) playerPoint |> traced (solid white) |> alpha 0.3
--    windOriginText = ((show (round absWindAngle)) ++ "&deg;")
--      |> baseText |> centered |> toForm
--      |> move (add playerPoint (fromPolar (20, toRadians absWindAngle))) |> alpha 0.6
--    playerProjection = segment playerPoint (0, snd playerPoint) |> traced (dotted white)
--    legend = "PLAYER\nSPEED" |> baseText |> centered |> toForm |> move (maxSpeed/2, -maxSpeed * 0.9)
--  in
--    group [yAxis, xAxis, polar, playerProjection, playerMark, playerSegment, windOriginText, legend]
--      |> move (-w/2 + 20, h/2 - maxSpeed/2 - 20)

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

renderLeaderboard: [String] -> (Float,Float) -> Maybe Form
renderLeaderboard leaderboard (w,h) =
  if (isEmpty leaderboard) then Nothing
  else
    indexedMap (\i n -> (show (i + 1) ++ ". " ++ n ++ "\n")) leaderboard
      |> concat
      |> baseText |> leftAligned |> toForm
      |> move (-w/2 + 50, 0)
      |> Just

renderHelp : Maybe Float -> (Float,Float) -> Maybe Form
renderHelp countdownMaybe (w,h) =
  if maybe True (\c -> c > 0) countdownMaybe then
    let text = helpMessage |> baseText |> centered |> toForm |> move (0, -h/2 + 50) |> alpha 0.8
    in Just text
  else
    Nothing

renderControls : GameState -> (Float,Float) -> Form
renderControls ({wind,player,opponents,course,now,countdown,center} as gameState) dims =
  let justForms =
        [ renderLapsCount dims course player
        --, renderPolar player dims
        , renderWindWheel wind player dims
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
        , renderHelp gameState.countdown dims
        , renderLeaderboard gameState.leaderboard dims
        ]
  in  group (justForms ++ (compact maybeForms))

