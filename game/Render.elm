module Render where

import Core (..)
import Geo (..)
import Game (..)
import String
import Text

import Debug

{-- Part 4: Display the game --------------------------------------------------

How should the GameState be displayed to the user?

Task: redefine `render` to use the GameState you defined in part 2.

------------------------------------------------------------------------------}

fullScreenMessage : String -> Form
fullScreenMessage msg = msg
  |> String.toUpper 
  |> toText 
  |> Text.height 100 
  |> Text.color white 
  |> monospace
  |> centered 
  |> toForm 
  |> alpha 0.3

baseText : String -> Text
baseText s =
  toText s
    |> Text.height 13
    |> Text.color white
    |> monospace


renderGate : Gate -> Float -> Maybe GateLocation -> Form
renderGate gate markRadius nextGate =
  let (left,right) = getGateMarks gate
      isNext = nextGate == Just gate.location
      line = segment left right |> traced (dotted orange)
      markStyle = if isNext then filled orange else filled white
      leftMark = circle markRadius |> markStyle |> move left
      rightMark = circle markRadius |> markStyle |> move right
      marks = [leftMark, rightMark]
  in
    if isNext then group (line :: marks) else group marks

renderHiddenGate : Gate -> (Float,Float) -> Point -> Maybe GateLocation -> Form
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
      (True, _) -> 
        let m = polygon [(0,0),(-c,-c),(c,-c)] |> markStyle
                                               |> move (-cx,(h/2))
            d = distance True |> move (-cx, h/2 - c*3) 
        in
          group [m, d]

      (_, True) -> 
        let m = polygon [(0,0),(-c,c),(c,c)]   |> markStyle
                                               |> move (-cx,(-h/2))
            d = distance False |> move (-cx, -h/2 + c*3) 
        in
          group [m,d]
      (_, _)    -> group []

renderBoatAngles : Boat -> Form
renderBoatAngles boat =
  let
    drawLine a = segment (fromPolar (15, a)) (fromPolar (25, a)) |> traced (solid white)
    directionLine = drawLine (toRadians boat.direction) |> alpha 0.8
    windLine = drawLine (toRadians (boat.direction - boat.windAngle)) |> alpha 0.3
    --tackLine = drawLine (toRadians (boat.direction - 2 * boat.windAngle)) |> alpha 0.2
    windAngleText = (show (abs boat.windAngle)) ++ "&deg;" |> baseText
      |> (if boat.controlMode == FixedWindAngle then line Under else id)
      |> centered |> toForm 
      |> move (fromPolar (40, toRadians (boat.direction - (boat.windAngle / 2))))
      |> alpha 0.8
  in
    group [directionLine, windLine, windAngleText] 


renderBoat : Boat -> Form
renderBoat boat =
  let 
    hull = image 8 19 "/assets/images/icon-boat-white.png"
      |> toForm
      |> rotate (toRadians (boat.direction + 90))
    angles = renderBoatAngles boat
  in 
    group [angles, hull]
      |> move boat.position


renderOpponent : Opponent -> Form
renderOpponent opponent =
  image 8 19 "/assets/images/icon-boat-white.png"
    |> toForm
    |> alpha 0.3
    |> rotate (toRadians (opponent.direction + 90))
    |> move (opponent.position.x,opponent.position.y)

renderEqualityLine : Point -> Float -> Form
renderEqualityLine (x,y) windOrigin =
  let left = (fromPolar (50, toRadians (windOrigin - 90)))
      right = (fromPolar (50, toRadians (windOrigin + 90)))
  in
    segment left right |> traced (dotted white) |> alpha 0.2 |> move (x,y)

renderBounds : (Point, Point) -> Form
renderBounds box =
  let (ne,sw) = box
      w = fst ne - fst sw
      h = snd ne - snd sw
      cw = (fst ne + fst sw) / 2
      ch = (snd ne + snd sw) / 2
  in rect w h |> filled (rgb 10 105 148)
              |> move (cw, ch)

renderCountdown : GameState -> Boat -> Form
renderCountdown gameState boat = 
  case gameState.countdown of 
    Just c -> 
      if | c > 0 -> let s = c |> inSeconds |> round
                        msg = (show s) ++ "\""
                    in fullScreenMessage msg
         | (isEmpty boat.passedGates) -> fullScreenMessage "Go!"
         | otherwise -> fullScreenMessage " " --toForm empty
    Nothing -> toForm empty

hasFinished : Course -> Opponent -> Bool
hasFinished course boat = (length boat.passedGates) == course.laps * 2 + 1

renderWinner : Course -> Boat -> [Opponent] -> Form
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
          fullScreenMessage "WINNER"
        else
          toForm empty
    else
      toForm empty

renderGust : Wind -> Gust -> Form
renderGust wind gust =
  let
    c = circle gust.radius |> filled black |> alpha (0.05 + gust.speedImpact / 2)
    --a = toRadians wind.origin
    --a' = toRadians (wind.origin + gust.originDelta)
    --s = segment (0,0) (fromPolar (gust.radius * 0.2, a))
    --  |> traced (solid white) |> alpha 0.1
    --s' = segment (0,0) (fromPolar (gust.radius * 0.5, a'))
    --  |> traced (solid white) |> alpha 0.1
  in
    group [c] |> move gust.position

renderGusts : Wind -> Form
renderGusts wind =
  group <| map (renderGust wind) wind.gusts

renderIslands : GameState -> Form
renderIslands gameState =
  let renderIsland i = circle i.radius |> filled (rgb 239 210 121) |> move i.location
  in
    group (map renderIsland gameState.islands)

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
    anglePoint a = fromPolar ((polarVelocity a) * 5, toRadians a)
    points = map anglePoint [0..180]
    maxSpeed = (map fst points |> maximum) + 10
    polar = path points |> traced (solid white)
    yAxis = segment (0,maxSpeed) (0,-maxSpeed) |> traced (solid white) |> alpha 0.5
    xAxis = segment (0,0) (maxSpeed,0) |> traced (solid white) |> alpha 0.5
    boatPoint = anglePoint (abs boat.windAngle)
    boatMark = circle 2 |> filled red |> move boatPoint
    boatProjection = segment boatPoint (0, snd boatPoint) |> traced (dotted white)
    legend = "VMG" |> baseText |> centered |> toForm |> move (maxSpeed / 2, maxSpeed * 0.8)
  in 
    group [yAxis, xAxis, polar, boatProjection, boatMark, legend] 
      |> move (-w/2 + 20, h/2 - maxSpeed - 20)

renderControlWheel : Wind -> Boat -> (Float,Float) -> Form
renderControlWheel wind boat (w,h) =
  let r = 25
      c = circle r |> outlined (solid white)
      windAngle = toRadians boat.windOrigin
      boatWindMarker = segment (fromPolar (r, windAngle)) (fromPolar (r + 8, windAngle))
        |> traced (solid white)
      boatAngle = toRadians boat.direction
      boatMarker = polygon [(0,4),(-4,-4),(4,-4)] 
                |> filled white
                |> rotate (boatAngle - pi/2)
                |> move (fromPolar (r - 4, boatAngle))
  in
      group [c, boatWindMarker, boatMarker] |> move (w/2 - 50, (h/2 - 80)) |> alpha 0.8


renderRelative : GameState -> Boat -> [Opponent] -> Form
renderRelative gameState boat opponents =
  let course = gameState.course
      nextGate = findNextGate boat course.laps
      downwindGate = renderGate course.downwind course.markRadius nextGate
      upwindGate = renderGate course.upwind course.markRadius nextGate
      bounds = renderBounds gameState.bounds
      boatPic = renderBoat boat
      opponentsPics = map (\b -> renderOpponent b) opponents |> group
      equalityLine = renderEqualityLine boat.position gameState.wind.origin
      islands = renderIslands gameState
      gusts = renderGusts gameState.wind
  in
      (group [bounds, islands, gusts, downwindGate, upwindGate, opponentsPics, equalityLine, boatPic]) |> move (neg boat.center)

renderAbsolute : GameState -> Boat -> [Opponent] -> (Float,Float) -> Form
renderAbsolute gameState boat opponents dims =
  let course = gameState.course
      nextGate = case gameState.countdown of 
        Just c -> if c <= 0 then findNextGate boat course.laps else Nothing
        Nothing -> Nothing
      countdown = renderCountdown gameState boat
      winner = renderWinner gameState.course boat opponents
      lapsCount = renderLapsCount dims gameState.course boat
      downwindHiddenGate = renderHiddenGate course.downwind dims boat.center nextGate
      upwindHiddenGate = renderHiddenGate course.upwind dims boat.center nextGate
      polar = renderPolar boat dims
      controlWheel = renderControlWheel wind boat dims
  in
      group [polar, controlWheel, upwindHiddenGate, downwindHiddenGate, lapsCount, countdown, winner]

renderRaceForBoat : (Int,Int) -> GameState -> Boat -> [Opponent] -> Element
renderRaceForBoat (w,h) gameState boat opponents =
  let dims = floatify (w,h)
      (w',h') = dims
      relativeToCenter = renderRelative gameState boat opponents
      absolute = renderAbsolute gameState boat opponents dims      
      bg = rect w' h' |> filled (rgb 239 210 121)
  in 
      layers [collage w h [bg, group [relativeToCenter, absolute]]]

render : (Int,Int) -> GameState -> Element
render (w,h) gameState =
  case gameState.otherBoat of
    Just otherBoat -> let w' = (div w 2) - 2
                          r1 = renderRaceForBoat (w',h) gameState gameState.boat (map boatToOpponent [otherBoat])
                          r2 = renderRaceForBoat (w',h) gameState otherBoat (map boatToOpponent [gameState.boat])
                      in flow left [r1, spacer 4 1, r2]
    Nothing        -> renderRaceForBoat (w,h) gameState gameState.boat gameState.opponents
