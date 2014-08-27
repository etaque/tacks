module Render.Absolute where

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


hasFinished : Course -> Boat a -> Bool
hasFinished course player = (length player.passedGates) == course.laps * 2 + 1

-- TODO repair
renderWinner : Course -> Player -> [Opponent] -> Maybe Form
renderWinner course player opponents =
  Nothing
  --if (hasFinished course player) then
  --  let finishTime : Opponent -> Time
  --      finishTime o = head o.passedGates
  --      othersTime = filter (hasFinished course) opponents |> map finishTime
  --      myTime = finishTime player
  --      othersAfterMe = all (\t -> t > myTime) othersTime
  --  in
  --    if (isEmpty othersTime) || othersAfterMe then
  --      Just (fullScreenMessage "WINNER")
  --    else
  --      Nothing
  --else
  --  Nothing

renderLapsCount : (Float,Float) -> Course -> Player -> Form
renderLapsCount (w,h) course player =
  let count = minimum [(div ((length player.passedGates) + 1) 2), course.laps]
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
    anglePoint a = fromPolar ((polarVelocity a) * 2, toRadians a)
    points = map anglePoint [0..180]
    maxSpeed = (map fst points |> maximum) + 10
    polar = path points |> traced (solid white)
    yAxis = segment (0,maxSpeed) (0,-maxSpeed) |> traced (solid white) |> alpha 0.6
    xAxis = segment (0,0) (maxSpeed,0) |> traced (solid white) |> alpha 0.6
    playerPoint = anglePoint absWindAngle
    playerMark = circle 2 |> filled red |> move playerPoint
    playerSegment = segment (0,0) playerPoint |> traced (solid white) |> alpha 0.3
    windOriginText = ((show absWindAngle) ++ "&deg;")
      |> baseText |> centered |> toForm
      |> move (add playerPoint (fromPolar (20, toRadians absWindAngle))) |> alpha 0.6
    playerProjection = segment playerPoint (0, snd playerPoint) |> traced (dotted white)
    legend = "VMG" |> baseText |> centered |> toForm |> move (maxSpeed / 2, maxSpeed * 0.8)
  in 
    group [yAxis, xAxis, polar, playerProjection, playerMark, playerSegment, windOriginText, legend] 
      |> move (-w/2 + 20, h/2 - maxSpeed - 20)

renderControlWheel : Wind -> Player -> (Float,Float) -> Form
renderControlWheel wind player (w,h) =
  let r = 35
      c = circle r |> outlined (solid white)
      windAngle = toRadians player.windOrigin
      playerWindMarker = segment (fromPolar (r, windAngle)) (fromPolar (r + 8, windAngle))
        |> traced (solid white)
      playerAngle = toRadians player.direction
      playerMarker = polygon [(0,4),(-4,-4),(4,-4)] 
        |> filled white
        |> rotate (playerAngle - pi/2)
        |> move (fromPolar (r - 4, playerAngle))
      windOriginText = ((show player.windOrigin) ++ "&deg;")
        |> baseText |> centered |> toForm
        |> rotate (windAngle - pi/2)
        |> move (fromPolar (r + 20, windAngle))

  in
      group [c, playerWindMarker, playerMarker, windOriginText] |> move (w/2 - 50, (h/2 - 120)) |> alpha 0.8

--renderLeaderboardLine : Int -> String -> Form
--renderLeaderboardLine index name = 
--  (show (index + 1)) ++ ". " ++ name 
--    |> baseText |> centered 
--    |> toForm 
--    |> move (0, (toFloat index) * -20)


--renderLeaderboard: [String] -> (Float,Float) -> Maybe Form
--renderLeaderboard leaderboard (w,h) =
--  if (isEmpty leaderboard) then Nothing
--  else
--    indexedMap renderLeaderboardLine leaderboard
--      |> group
--      |> move (w/2 - 50, 0)
--      |> Just

renderHelp : Float -> (Float,Float) -> Maybe Form
renderHelp countdown (w,h) = 
  if countdown > 0 then
    let text = helpMessage |> baseText |> centered |> toForm |> move (0, -h/2 + 50) |> alpha 0.8
    in Just text
  else
    Nothing

renderAbsolute : GameState -> (Float,Float) -> Form
renderAbsolute ({player,opponents,course} as gameState) dims =
  let nextGate = if gameState.countdown <= 0 
        then findNextGate player course.laps 
        else Nothing
      justForms = [
        renderLapsCount dims course player,
        renderPolar player dims,
        renderControlWheel wind player dims
      ]
      maybeForms = [
        renderHiddenGate course.downwind dims player.center (nextGate == Just Downwind),
        renderHiddenGate course.upwind dims player.center (nextGate == Just Upwind),
        renderWinner course player opponents,
        renderHelp gameState.countdown dims
        --renderLeaderboard gameState.leaderboard dims
      ]
  in
      group (justForms ++ (compact maybeForms))

