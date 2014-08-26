module Render.Absolute where

import Core (..)
import Geo (..)
import Game (..)
import String
import Text

helpMessage : String
helpMessage = "←/→ to turn left/right, ↓←/↓→ to fine tune direction, ↑ or ENTER to lock angle to wind, SPACE to tack/jibe"

fullScreenMessage : String -> Form
fullScreenMessage msg = msg
  |> String.toUpper 
  |> toText 
  |> Text.height 60 
  |> Text.color white 
  |> centered 
  |> toForm 
  |> alpha 0.3

renderHiddenGate : Gate -> (Float,Float) -> Point -> Maybe GateLocation -> Maybe Form
renderHiddenGate gate (w,h) (cx,cy) nextGate =
  let (left,right) = getGateMarks gate
      isNext = nextGate == Just gate.location
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

renderCountdown : GameState -> Boat -> Maybe Form
renderCountdown gameState boat = 
  if | gameState.countdown > 0 -> 
         let cs = gameState.countdown |> inSeconds |> round
             m = cs `div` 60
             s = cs `rem` 60
             msg = (show m) ++ "' " ++ (show s) ++ "\""
         in Just (fullScreenMessage msg)
     | (isEmpty boat.passedGates) -> Just (fullScreenMessage "Go!")
     | otherwise -> Nothing

hasFinished : Course -> Opponent -> Bool
hasFinished course boat = (length boat.passedGates) == course.laps * 2 + 1

renderWinner : Course -> Boat -> [Opponent] -> Maybe Form
renderWinner course boat opponents =
  let me = boatToOpponent boat
  in
    if (hasFinished course me) then
      let finishTime : Opponent -> Time
          finishTime o = head o.passedGates
          othersTime = filter (hasFinished course) opponents |> map finishTime
          myTime = finishTime me
          othersAfterMe = all (\t -> t > myTime) othersTime
      in
        if (isEmpty othersTime) || othersAfterMe then
          Just (fullScreenMessage "WINNER")
        else
          Nothing
    else
      Nothing

renderLapsCount : (Float,Float) -> Course -> Boat -> Form
renderLapsCount (w,h) course boat =
  let count = minimum [(div ((length boat.passedGates) + 1) 2), course.laps]
      msg = "LAP " ++ (show count) ++ "/" ++ (show course.laps)
  in msg
      |> baseText
      |> rightAligned
      |> toForm
      |> move (w / 2 - 50, h / 2 - 30)

renderPolar : Boat -> (Float,Float) -> Form
renderPolar boat (w,h) =
  let 
    absWindAngle = abs boat.windAngle
    anglePoint a = fromPolar ((polarVelocity a) * 2, toRadians a)
    points = map anglePoint [0..180]
    maxSpeed = (map fst points |> maximum) + 10
    polar = path points |> traced (solid white)
    yAxis = segment (0,maxSpeed) (0,-maxSpeed) |> traced (solid white) |> alpha 0.6
    xAxis = segment (0,0) (maxSpeed,0) |> traced (solid white) |> alpha 0.6
    boatPoint = anglePoint absWindAngle
    boatMark = circle 2 |> filled red |> move boatPoint
    boatSegment = segment (0,0) boatPoint |> traced (solid white) |> alpha 0.3
    windOriginText = ((show absWindAngle) ++ "&deg;")
      |> baseText |> centered |> toForm
      |> move (add boatPoint (fromPolar (20, toRadians absWindAngle))) |> alpha 0.6
    boatProjection = segment boatPoint (0, snd boatPoint) |> traced (dotted white)
    legend = "VMG" |> baseText |> centered |> toForm |> move (maxSpeed / 2, maxSpeed * 0.8)
  in 
    group [yAxis, xAxis, polar, boatProjection, boatMark, boatSegment, windOriginText, legend] 
      |> move (-w/2 + 20, h/2 - maxSpeed - 20)

renderControlWheel : Wind -> Boat -> (Float,Float) -> Form
renderControlWheel wind boat (w,h) =
  let r = 35
      c = circle r |> outlined (solid white)
      windAngle = toRadians boat.windOrigin
      boatWindMarker = segment (fromPolar (r, windAngle)) (fromPolar (r + 8, windAngle))
        |> traced (solid white)
      boatAngle = toRadians boat.direction
      boatMarker = polygon [(0,4),(-4,-4),(4,-4)] 
        |> filled white
        |> rotate (boatAngle - pi/2)
        |> move (fromPolar (r - 4, boatAngle))
      windOriginText = ((show boat.windOrigin) ++ "&deg;")
        |> baseText |> centered |> toForm
        |> rotate (windAngle - pi/2)
        |> move (fromPolar (r + 20, windAngle))

  in
      group [c, boatWindMarker, boatMarker, windOriginText] |> move (w/2 - 50, (h/2 - 120)) |> alpha 0.8

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
renderAbsolute ({boat,opponents,course} as gameState) dims =
  let nextGate = if gameState.countdown <= 0 
        then findNextGate boat course.laps 
        else Nothing
      justForms = [
        renderLapsCount dims course boat,
        renderPolar boat dims,
        renderControlWheel wind boat dims
      ]
      maybeForms = [
        renderHiddenGate course.downwind dims boat.center nextGate,
        renderHiddenGate course.upwind dims boat.center nextGate,
        renderCountdown gameState boat,
        renderWinner course boat opponents,
        renderHelp gameState.countdown dims
        --renderLeaderboard gameState.leaderboard dims
      ]
  in
      group (justForms ++ (compact maybeForms))

