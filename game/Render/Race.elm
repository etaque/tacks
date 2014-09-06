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

renderPlayerAngles : Player -> Form
renderPlayerAngles player =
  let windOriginRadians = toRadians (player.direction - player.windAngle)
      windMarker = polygon [(0,4),(-4,-4),(4,-4)]
        |> filled white
        |> rotate (windOriginRadians + pi/2)
        |> move (fromPolar (25, windOriginRadians))
        |> alpha 0.5
      windAngleText = (show (abs (round player.windAngle))) ++ "&deg;" |> baseText
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
  let pairs = if (isEmpty wake) then [] else zip wake (tail wake) |> indexedMap (,)
      style = { defaultLine | color <- white, width <- 3 }
      opacityForIndex i = 0.3 - 0.3 * (toFloat i) / (toFloat (length wake))
      renderSegment (i,(a,b)) = segment a b |> traced style |> alpha (opacityForIndex i)
  in  group (map renderSegment pairs)

renderPlayer : Player -> [Spell] -> Form
renderPlayer player spells =
  let boatPath = if(containsSpell "PoleInversion" spells) then "monohull-black" else "monohull"
      hull = image 8 19 ("/assets/images/" ++ boatPath ++ ".png") |> toForm
        |> rotate (toRadians (player.direction + 90))
      angles = renderPlayerAngles player
      eqLine = renderEqualityLine player.position player.windOrigin
      -- fog = oval (100 + (mod (round (fst player.position)) 100)) 180
      fog1 = oval 190 250
        |> filled grey
        |> rotate (snd player.position / 60)
      fog2 = oval 170 230
        |> filled white
        |> rotate (fst player.position / 41 + 220)
        |> alpha 0.8
      fog = if (containsSpell "Fog" spells) then [fog1, fog2] else []
      movingPart = group ([angles, eqLine, hull] ++ fog) |> move player.position
      wake = renderWake player.wake
  in group [movingPart, wake]

renderOpponent : Opponent -> Form
renderOpponent opponent =
  let hull = image 8 19 "/assets/images/monohull.png" |> toForm
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

renderBuoy : Time -> Buoy -> Form
renderBuoy timer {position,radius,spell} =
  let a = 0.4 + 0.2 * cos (timer * 0.005)
  in  circle radius |> filled colors.buoy |> move position |> alpha a

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
    Just Upwind   -> Just <| renderGateLaylines player.upwindVmg player.windOrigin course.upwind
    Just Downwind -> Just <| renderGateLaylines player.downwindVmg player.windOrigin course.downwind
    _             -> Nothing

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
            else if player.nextGate == Just StartLine
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
renderRace ({player,opponents,course,buoys,triggeredSpells,now} as gameState) =
  let downwindOrStartLine = if isEmpty player.crossedGates
        then renderStartLine course.downwind course.markRadius (isStarted gameState.countdown) now
        else renderGate course.downwind course.markRadius (player.nextGate == Just Downwind)
      justForms =
        [ renderBounds gameState.course.bounds
        , renderIslands gameState
        , downwindOrStartLine
        , renderGate course.upwind course.markRadius (player.nextGate == Just Upwind)
        , group (map renderOpponent opponents)
        , renderGusts gameState.wind
        , renderPlayer player triggeredSpells
        ]
      maybeForms =
        [ renderCountdown gameState player
        , mapMaybe (\c -> group (map (renderBuoy c) buoys)) gameState.countdown
        , renderLaylines player course
        , renderFinished gameState.course player
        ]
  in  group (justForms ++ (compact maybeForms)) |> move (neg player.center)

