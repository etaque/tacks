module Render.Race where

import Render.Utils (..)
import Core (..)
import Geo (..)
import Game (..)
import String
import Text

import Debug

renderStartLine : Gate -> Float -> Bool -> Form
renderStartLine gate markRadius started =
  let lineStyle = if started then dotted white else solid white
      markColor = if started then green else red
      line = segment left right |> traced lineStyle
      (left,right) = getGateMarks gate
      marks = map (\g -> circle markRadius |> filled markColor |> move g) [left, right]
  in  group (line :: marks)

renderGate : Gate -> Float -> Bool -> Form
renderGate gate markRadius isNext =
  let (left,right) = getGateMarks gate
      (markStyle,lineStyle) =
        if isNext
          then (filled orange, traced (dotted orange))
          else (filled white, traced (solid colors.seaBlue))
      line = segment left right |> lineStyle
      leftMark = circle markRadius |> markStyle |> move left
      rightMark = circle markRadius |> markStyle |> move right
  in  group [line, leftMark, rightMark]

renderPlayerAngles : Player -> Form
renderPlayerAngles player =
  let windOriginRadians = toRadians (player.direction - player.windAngle)
      windMarker = polygon [(0,4),(-4,-4),(4,-4)]
        |> filled white
        |> rotate (windOriginRadians + pi/2)
        |> move (fromPolar (25, windOriginRadians))
        |> alpha 0.5
      windAngleText = (show (abs player.windAngle)) ++ "&deg;" |> baseText
        |> (if player.controlMode == FixedWindAngle then line Under else id)
        |> centered |> toForm
        |> move (fromPolar (25, windOriginRadians + pi))
        |> alpha 0.5
  in  group [windMarker, windAngleText]

renderEqualityLine : Point -> Float -> Form
renderEqualityLine (x,y) windOrigin =
  let left = (fromPolar (50, toRadians (windOrigin - 90)))
      right = (fromPolar (50, toRadians (windOrigin + 90)))
  in  segment left right |> traced (dotted white) |> alpha 0.2

renderWake : [Point] -> Form
renderWake wake =
  let span = 5
      opacityForIndex i = 0.5 - 0.4 * (toFloat i) / (toFloat (length wake))
      renderWakePoint (i, p) = circle 2 |> filled white |> move p |> alpha (opacityForIndex i)
      points = indexedMap (,) wake |> filter (\(i,p) -> ((i+1) `mod` span) == 0) |> map renderWakePoint
  in  group points

renderPlayer : Player -> Form
renderPlayer player =
  let hull = image 11 20 "/assets/images/icon-ac72.png" |> toForm
        |> rotate (toRadians (player.direction + 90))
      angles = renderPlayerAngles player
      eqLine = renderEqualityLine player.position player.windOrigin
      movingPart = group [angles, eqLine, hull] |> move player.position
      wake = renderWake player.wake
  in group [movingPart, wake]

renderOpponent : Opponent -> Form
renderOpponent opponent =
  let hull = image 11 20 "/assets/images/icon-ac72.png" |> toForm
        |> rotate (toRadians (opponent.direction + 90))
        |> move opponent.position
        |> alpha 0.5
      name = opponent.name |> baseText |> centered |> toForm
        |> move (add opponent.position (0,-25))
        |> alpha 0.3
  in group [hull, name]


renderBounds : (Point, Point) -> Form
renderBounds box =
  let (ne,sw) = box
      w = fst ne - fst sw
      h = snd ne - snd sw
      cw = (fst ne + fst sw) / 2
      ch = (snd ne + snd sw) / 2
  in rect w h |> filled colors.seaBlue
              |> move (cw, ch)

renderGust : Wind -> Gust -> Form
renderGust wind gust =
  circle gust.radius |> filled black |> alpha 0.2 |> move gust.position

renderGusts : Wind -> Form
renderGusts wind =
  group <| map (renderGust wind) wind.gusts

renderIsland : Island -> Form
renderIsland {location,radius} =
  circle radius |> filled colors.sand |> move location

renderIslands : GameState -> Form
renderIslands gameState =
  group (map renderIsland gameState.course.islands)

renderBuoy : Buoy -> Form
renderBuoy {position,radius,spell} =
  circle radius |> filled colors.buoy |> move position

renderLaylines : Player -> Course -> Form
renderLaylines player course =
  let upwindVmgAngleR = toRadians upwindVmg
      upwindMark = course.upwind
      (left,right) = getGateMarks upwindMark
      windAngleR = toRadians player.windOrigin

      leftLL = add left (fromPolar (500, windAngleR + upwindVmgAngleR - pi))

      l1 = segment left leftLL |> traced (solid white)
  in group [l1] |> alpha 0.3

renderCountdown : GameState -> Player -> Maybe Form
renderCountdown gameState player =
  let messageBuilder msg = baseText msg |> centered |> toForm |> move (0, gameState.course.downwind.y + 50)
  in  if | gameState.countdown > 0 ->
             let cs = gameState.countdown |> inSeconds |> ceiling
                 m = cs `div` 60
                 s = cs `rem` 60
                 msg = "Start in " ++ (show m) ++ "'" ++ (show s) ++ "\"..."
             in  Just (messageBuilder msg)
         | (isEmpty player.passedGates) -> Just (messageBuilder "Go!")
         | otherwise -> Nothing

renderRelative : GameState -> Form
renderRelative ({player,opponents,course,buoys} as gameState) =
  let nextGate = findNextGate player course.laps
      downwindOrStartLine = if isEmpty player.passedGates
        then renderStartLine course.downwind course.markRadius (gameState.countdown <= 0)
        else renderGate course.downwind course.markRadius (nextGate == Just Downwind)
      justForms = [
        renderBounds gameState.course.bounds,
        renderIslands gameState,
        downwindOrStartLine,
        renderGate course.upwind course.markRadius (nextGate == Just Upwind),
        --renderLaylines player gameState.course,
        renderPlayer player,
        group (map renderOpponent opponents),
        group (map renderBuoy buoys),
        renderGusts gameState.wind
      ]
      maybeForms = [
        renderCountdown gameState player
      ]
  in  group (justForms ++ (compact maybeForms)) |> move (neg player.center)

