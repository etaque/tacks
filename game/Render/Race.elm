module Render.Race where

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

vmgColorAndShape : Player -> (Color, Shape)
vmgColorAndShape player =
  let a = (abs player.windAngle)
      margin = 3
      s = 4
      bad = (red, rect (s*2) (s*2))
      good = (green, circle s)
      warn = (orange, polygon [(-s,-s),(s,-s),(0,s)])
  in  if a < 90 then
        if | a < player.upwindVmg - margin -> bad
           | a > player.upwindVmg + margin -> warn
           | otherwise                     -> good
      else
        if | a > player.downwindVmg + margin -> bad
           | a < player.downwindVmg - margin -> warn
           | otherwise                       -> good

renderPlayerAngles : Player -> Form
renderPlayerAngles player =
  let windOriginRadians = toRadians (player.heading - player.windAngle)
      windMarker = polygon [(0,4),(-4,-4),(4,-4)]
        |> filled white
        |> rotate (windOriginRadians + pi/2)
        |> move (fromPolar (25, windOriginRadians))
        |> alpha 0.5
      windAngleText = (show (abs (round player.windAngle))) ++ "&deg;" |> baseText
        |> (if player.controlMode == "FixedAngle" then line Under else id)
        |> centered |> toForm
        |> move (fromPolar (25, windOriginRadians + pi))
        |> alpha 0.5
      (vmgColor,vmgShape) = vmgColorAndShape player
      vmgIndicator = group [vmgShape |> filled vmgColor, vmgShape |> outlined (solid white)]
        |> move (fromPolar(25, windOriginRadians + pi/2))

  in  group [windMarker, windAngleText, vmgIndicator]

renderEqualityLine : Point -> Float -> Form
renderEqualityLine (x,y) windOrigin =
  let left = (fromPolar (50, toRadians (windOrigin - 90)))
      right = (fromPolar (50, toRadians (windOrigin + 90)))
  in  segment left right |> traced (dotted white) |> alpha 0.2

renderWake : [Point] -> Form
renderWake wake =
  let pairs = if (isEmpty wake) then [] else zip wake (tail wake) |> indexedMap (,)
      style = { defaultLine | color <- white, width <- 3 }
      opacityForIndex i = 0.3 - 0.3 * (toFloat i) / (toFloat (length wake))
      renderSegment (i,(a,b)) = segment a b |> traced style |> alpha (opacityForIndex i)
  in  group (map renderSegment pairs)

renderWindShadow : Float -> Boat a -> Form
renderWindShadow shadowLength boat =
  let shadowDirection = (ensure360 (boat.windOrigin + 180 + (boat.windAngle / 3)))
      arcAngles = [-15, -10, -5, 0, 5, 10, 15]
      endPoints = map (\a -> add boat.position (fromPolar (shadowLength, toRadians (shadowDirection + a)))) arcAngles
  in  path (boat.position :: endPoints) |> filled white |> alpha 0.1

renderBoatIcon : Boat a -> String -> Form
renderBoatIcon boat name =
  image 12 20 ("/assets/images/" ++ name ++ ".png") |> toForm
    |> rotate (toRadians (boat.heading + 90))

renderPlayer : Player -> Float -> Form
renderPlayer player shadowLength =
  let hull = renderBoatIcon player "49er"
      windShadow = renderWindShadow shadowLength player
      angles = renderPlayerAngles player
      eqLine = renderEqualityLine player.position player.windOrigin
      movingPart = group [angles, eqLine, hull] |> move player.position
      wake = renderWake player.trail
  in group [wake, windShadow, movingPart]

renderOpponent : Float -> Opponent -> Form
renderOpponent shadowLength opponent =
  let hull = renderBoatIcon opponent "49er"
        |> move opponent.position
        |> alpha 0.5
      shadow = renderWindShadow shadowLength opponent
      name = opponent.player.name |> baseText |> centered |> toForm
        |> move (add opponent.position (0,-25))
        |> alpha 0.3
  in group [shadow, hull, name]


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

renderIsland : Island -> Form
renderIsland {location,radius} =
  circle radius |> filled colors.sand |> move location

renderIslands : GameState -> Form
renderIslands gameState =
  group (map renderIsland gameState.course.islands)

renderGateLaylines : Float -> Float -> Gate -> Form
renderGateLaylines vmg windOrigin gate =
  let vmgRad = toRadians vmg
      (leftMark,rightMark) = getGateMarks gate
      windAngleRad = toRadians windOrigin
      leftLineEnd = add leftMark (fromPolar (1000, windAngleRad + vmgRad + pi/2))
      rightLineEnd = add rightMark (fromPolar (1000, windAngleRad - vmgRad - pi/2))
      drawLine (p1,p2) = segment p1 p2 |> traced (solid white)
  in  group (map drawLine [(leftMark, leftLineEnd), (rightMark, rightLineEnd)]) |> alpha 0.3

renderLaylines : Player -> Course -> Maybe Form
renderLaylines player course =
  case player.nextGate of
    Just "UpwindGate"   -> Just <| renderGateLaylines player.upwindVmg player.windOrigin course.upwind
    Just "DownwindGate" -> Just <| renderGateLaylines player.downwindVmg player.windOrigin course.downwind
    _                   -> Nothing

formatCountdown : Time -> String
formatCountdown c =
  let cs = c |> inSeconds |> ceiling
      m = cs `div` 60
      s = cs `rem` 60
  in  "Start in " ++ (show m) ++ "'" ++ (show s) ++ "\"..."

renderCountdown : GameState -> Player -> Maybe Form
renderCountdown gameState player =
  let messageBuilder msg = baseText msg |> centered |> toForm |> move (0, gameState.course.downwind.y + 40)
  in  case gameState.countdown of
        Just c ->
          if c > 0
            then Just <| messageBuilder (formatCountdown (getCountdown gameState.countdown))
            else if player.nextGate == Just "StartLine"
              then Just <| messageBuilder "Go!"
              else Nothing
        Nothing ->
          if gameState.isMaster
            then Just <| messageBuilder startCountdownMessage
            else Nothing

renderFinished : Course -> Player -> Maybe Form
renderFinished course player =
  case player.nextGate of
    Nothing -> Just (baseText "Finished!" |> centered |> toForm |> move (0, course.downwind.y + 40))
    _       -> Nothing

renderRace : GameState -> Form
renderRace ({player,opponents,course,now,center} as gameState) =
  let downwindOrStartLine = if isEmpty player.crossedGates
        then renderStartLine course.downwind course.markRadius (isStarted gameState.countdown) now
        else renderGate course.downwind course.markRadius (player.nextGate == Just "DownwindGate")
      justForms =
        [ renderBounds gameState.course.area
        , renderIslands gameState
        , downwindOrStartLine
        , renderGate course.upwind course.markRadius (player.nextGate == Just "UpwindGate")
        , group (map (renderOpponent course.windShadowLength) opponents)
        , renderGusts gameState.wind
        , renderPlayer player course.windShadowLength
        ]
      maybeForms =
        [ renderCountdown gameState player
        , renderLaylines player course
        , renderFinished gameState.course player
        ]
  in  group (justForms ++ (compact maybeForms)) |> move (neg center)

