module Render.Controls where

import Render.Utils (..)
import Core (..)
import Geo (..)
import Game (..)
import String
import Text

renderHiddenGate : Gate -> (Float,Float) -> Point -> Bool -> Maybe Form
renderHiddenGate gate (w,h) (cx,cy) isNext =
  let (left,right) = getGateMarks gate
      c = 5
      over = cy + h/2 + c < gate.y
      under = cy - h/2 - c > gate.y
      markStyle = if isNext then filled orange else filled white
      distance isOver = round (abs (gate.y + (if isOver then -h else h)/2 - cy)) |> show |> baseText |> centered |> toForm
  in
    case (over, under) of
      (True, _) -> let m = polygon [(0,0),(-c,-c),(c,-c)] |> markStyle |> move (-cx,(h/2))
                       d = distance True |> move (-cx, h/2 - c*3)
                   in  Just (group [m, d])
      (_, True) -> let m = polygon [(0,0),(-c,c),(c,c)] |> markStyle |> move (-cx,(-h/2))
                       d = distance False |> move (-cx, -h/2 + c*3)
                   in  Just (group [m,d])
      (_, _)    -> Nothing


renderLapsCount : (Float,Float) -> Course -> Player -> Form
renderLapsCount (w,h) course player =
  let count = minimum [(div ((length player.crossedGates) + 1) 2), course.laps]
      msg = "LAP " ++ (show count) ++ "/" ++ (show course.laps)
  in msg
      |> baseText
      |> rightAligned
      |> toForm
      |> move (w / 2 - 50, h / 2 - 30)

renderPolar : Player -> (Float,Float) -> Form
renderPolar player (w,h) =
  let
    absWindAngle = abs player.windAngle
    anglePoint a = fromPolar ((polarVelocity player.windSpeed a), toRadians a)
    points = map anglePoint [0..180]
    maxSpeed = 100
    polar = path points |> traced (solid white)
    yAxis = segment (0,(maxSpeed/2)) (0,-maxSpeed) |> traced (solid white) |> alpha 0.6
    xAxis = segment (0,0) (maxSpeed,0) |> traced (solid white) |> alpha 0.6
    playerPoint = anglePoint absWindAngle
    playerMark = circle 2 |> filled red |> move playerPoint
    playerSegment = segment (0,0) playerPoint |> traced (solid white) |> alpha 0.3
    windOriginText = ((show (round absWindAngle)) ++ "&deg;")
      |> baseText |> centered |> toForm
      |> move (add playerPoint (fromPolar (20, toRadians absWindAngle))) |> alpha 0.6
    playerProjection = segment playerPoint (0, snd playerPoint) |> traced (dotted white)
    legend = "PLAYER\nSPEED" |> baseText |> centered |> toForm |> move (maxSpeed/2, -maxSpeed * 0.9)
  in
    group [yAxis, xAxis, polar, playerProjection, playerMark, playerSegment, windOriginText, legend]
      |> move (-w/2 + 20, h/2 - maxSpeed/2 - 20)

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
        |> rotate (windOriginRadians - pi/2)
        |> move (fromPolar (r + 20, windOriginRadians))
      windSpeedText = ((show (round wind.speed)) ++ "kn")
        |> baseText |> centered |> toForm
      legend = "WIND" |> baseText |> centered |> toForm |> move (0, -50)

  in  group [c, windMarker, windOriginText, windSpeedText, legend] |> move (w/2 - 50, (h/2 - 120)) |> alpha 0.8

renderStockSpell : Spell -> (Float, Float) -> Form
renderStockSpell spell (w,h) =
  let spellLabel = "SPELL"
        |> baseText
        |> centered
        |> toForm
        |> move (0, 35)
      outlineSquare = square 35
        |> outlined (solid white)
      spellGraphics = getSpellStockGraphic spell.kind
  in  group [spellLabel, outlineSquare, spellGraphics]
        |> move (w/2 - 45, h/2 - 250)

renderPoleInversion =
  let arrow = map (scale 3) getArrow
        |> polygon
        |> filled white
      leftArrow = arrow
        |> move (-1, 6)
      rightArrow = arrow
        |> rotate (degrees 180)
        |> move (1, -6)
  in  group [leftArrow, rightArrow]

renderFog =
  let upLine = segment (-12, -8) (12, -8)
        |> traced { defaultLine | width <- 5,
                                  color <- white }
        |> alpha 0.6
      midLine = upLine |> move (0, 8)
      botLine = upLine |> move (0, 16)
  in  group [upLine, midLine, botLine]

getSpellStockGraphic : String -> Form
getSpellStockGraphic kind =
  case kind of
    "PoleInversion" -> renderPoleInversion
    "Fog" -> renderFog

getArrow : Path
getArrow =
  [ (-3, 1)
  , (1, 1)
  , (1, 2)
  , (3, 0)
  , (1, -2)
  , (1, -1)
  , (-3, -1)
  ]

renderLeaderboard: [String] -> (Float,Float) -> Maybe Form
renderLeaderboard leaderboard (w,h) =
  if (isEmpty leaderboard) then Nothing
  else
    indexedMap (\i n -> (show (i + 1) ++ ". " ++ n ++ "\n")) leaderboard
      |> concat
      |> baseText |> leftAligned |> toForm
      |> move (w/2 - 50, 0)
      |> Just

renderHelp : Maybe Float -> (Float,Float) -> Maybe Form
renderHelp countdownMaybe (w,h) =
  if maybe True (\c -> c > 0) countdownMaybe then
    let text = helpMessage |> baseText |> centered |> toForm |> move (0, -h/2 + 50) |> alpha 0.8
    in Just text
  else
    Nothing

renderAbsolute : GameState -> (Float,Float) -> Form
renderAbsolute ({wind,player,opponents,course,playerSpell} as gameState) dims =
  let justForms =
        [ renderLapsCount dims course player
        , renderPolar player dims
        , renderWindWheel wind player dims
        ]
      maybeForms =
        [ renderHiddenGate course.downwind dims player.center (player.nextGate == Just Downwind)
        , renderHiddenGate course.upwind dims player.center (player.nextGate == Just Upwind)
        , renderHelp gameState.countdown dims
        , renderLeaderboard gameState.leaderboard dims
        , case playerSpell of
            Just spell -> Just (renderStockSpell spell dims)
            Nothing -> Nothing
        ]
  in  group (justForms ++ (compact maybeForms))

