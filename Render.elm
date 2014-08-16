module Render where

import Core (..)
import Geo (..)
import Game (..)
import String
import Text

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

renderLapsCount : (Float,Float) -> Course -> Boat -> Form
renderLapsCount (w,h) course boat =
  let count = ((length boat.passedGates) + 1) |> div 2
      msg = "LAP " ++ (show count) ++ "/" ++ (show course.laps)
  in msg
      |> baseText
      |> rightAligned
      |> toForm
      |> move (w / 2 - 40, h / 2 - 15)

renderGate : Gate -> Maybe GateLocation -> Form
renderGate gate nextGate =
  let (left,right) = getGateMarks gate
      isNext = nextGate == Just gate.location
      line = segment left right |> traced (dotted orange)
      markStyle = if isNext then filled orange else filled white
      leftMark = circle gate.markRadius |> markStyle |> move left
      rightMark = circle gate.markRadius |> markStyle |> move right
      marks = [leftMark, rightMark]
  in
    if isNext then group (line :: marks) else group marks

renderHiddenGate : Gate -> (Float,Float) -> Point -> Maybe GateLocation -> Form
renderHiddenGate gate (w,h) (cx,cy) nextGate =
  let (left,right) = getGateMarks gate
      isNext = nextGate == Just gate.location
      c = 5
      over = cy + h/2 + c < gate.y
      under = cy - h/2 - c> gate.y
      markStyle = if isNext then filled orange else filled white
      distance = round (abs (gate.y - h/2 - cy)) |> show |> baseText |> centered |> toForm
  in 
    case (over, under) of
      (True, _) -> 
        let m = polygon [(0,0),(-c,-c),(c,-c)] |> markStyle
                                               |> move (-cx,(h/2))
            d = distance |> move (-cx, h/2 - c*3) 
        in
          group [m, d]

      (_, True) -> 
        let m = polygon [(0,0),(-c,c),(c,c)]   |> markStyle
                                               |> move (-cx,(-h/2))
            d = distance |> move (-cx, -h/2 + c*3) 
        in
          group [m,d]
      (_, _)    -> group []

renderBoatAngles : Boat -> Form
renderBoatAngles boat =
  let
    drawLine a = segment (fromPolar (15, a)) (fromPolar (25, a)) |> traced (solid white)
    directionLine = drawLine (toRadians boat.direction) |> alpha 0.5
    windLine = drawLine (toRadians (boat.direction - boat.windAngle)) |> alpha 0.5
    --tackLine = drawLine (toRadians (boat.direction - 2 * boat.windAngle)) |> alpha 0.2
    windAngleText = (show (abs boat.windAngle)) ++ "&deg;" |> baseText
      |> (if boat.controlMode == FixedWindAngle then line Under else id)
      |> centered |> toForm 
      |> move (fromPolar (40, toRadians (boat.direction - (div boat.windAngle 2))))
      |> alpha 0.5
  in
    group [directionLine, windLine, windAngleText] 


renderBoat : Boat -> Bool -> Form
renderBoat boat isMain =
  let 
    hull = image 8 19 "/icon-boat-white.png"
      |> toForm
      |> alpha (if isMain then 1 else 0.3)
      |> rotate (toRadians (boat.direction + 90))
    angles = if isMain then renderBoatAngles boat else toForm empty
  in 
    group [angles, hull]
      |> move boat.position

renderEqualityLine : Point -> Int -> Form
renderEqualityLine (x,y) windOrigin =
  segment (x - 100, y) (x + 100, y) |> traced (solid black)

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
         | otherwise -> toForm empty
    Nothing -> toForm empty

hasFinished : Course -> Boat -> Bool
hasFinished course boat = (length boat.passedGates) == course.laps * 2 + 1

renderWinner : Course -> Boat -> [Boat] -> Form
renderWinner course boat otherBoats =
  if (hasFinished course boat) then
    let finishTime b = snd (head b.passedGates)
        othersTime = filter (hasFinished course) otherBoats |> map finishTime
        myTime = finishTime boat
        othersAfterMe = all (\t -> t > myTime) othersTime
    in
      if (isEmpty othersTime) || othersAfterMe then
        fullScreenMessage "WINNER"
      else
        toForm empty
  else
    toForm empty

renderIslands : GameState -> Form
renderIslands gameState =
  let renderIsland i = circle i.radius |> filled (rgb 239 210 121) |> move i.location
  in
    group (map renderIsland gameState.islands)

renderRelative : GameState -> Boat -> [Boat] -> Form
renderRelative gameState boat otherBoats =
  let course = gameState.course
      nextGate = case gameState.countdown of 
        Just c -> if c <= 0 then findNextGate boat course.laps else Nothing
        Nothing -> Nothing
      downwindGate = renderGate course.downwind nextGate
      upwindGate = renderGate course.upwind nextGate
      bounds = renderBounds gameState.bounds
      boatPic = renderBoat boat True
      otherBoatsPics = map (\b -> renderBoat b False) otherBoats |> group
      equalityLine = renderEqualityLine boat.position gameState.wind.origin
      islands = renderIslands gameState
  in
      (group [bounds, islands, downwindGate, upwindGate, otherBoatsPics, boatPic]) |> move (neg boat.center)

renderAbsolute : GameState -> Boat -> [Boat] -> (Float,Float) -> Form
renderAbsolute gameState boat otherBoats dims =
  let course = gameState.course
      nextGate = case gameState.countdown of 
        Just c -> if c <= 0 then findNextGate boat course.laps else Nothing
        Nothing -> Nothing
      countdown = renderCountdown gameState boat
      winner = renderWinner gameState.course boat otherBoats
      lapsCount = renderLapsCount dims gameState.course boat
      downwindHiddenGate = renderHiddenGate course.downwind dims boat.center nextGate
      upwindHiddenGate = renderHiddenGate course.upwind dims boat.center nextGate
  in
      group [upwindHiddenGate, downwindHiddenGate, lapsCount, countdown, winner]

renderRace : GameState -> Boat -> [Boat] -> (Float,Float) -> Form
renderRace gameState boat otherBoats dims =
  let relativeToCenter = renderRelative gameState boat otherBoats
      absolute = renderAbsolute gameState boat otherBoats dims
  in  group [relativeToCenter, absolute]

--renderControlWheel : Wind -> Boat -> Element
--renderControlWheel wind boat =
--  let bg = circle 30 |> filled white
--      windAngle = toRadians wind.origin
--      windMarker = polygon [(0,4),(-4,-4),(4,-4)] 
--                |> filled white 
--                |> rotate (windAngle + pi/2)
--                |> move (fromPolar (34, windAngle))
--      boatAngle = toRadians boat.direction
--      boatMarker = polygon [(0,4),(-4,-4),(4,-4)] 
--                |> filled black
--                |> rotate (boatAngle - pi/2)
--                |> move (fromPolar (26, boatAngle))
--      fmt = if boat.controlMode == FixedWindAngle then line Under else id
--      windAngleText = boat.windAngle |> abs |> show |> toText |> monospace |> fmt |> centered |> toForm
--  in
--      collage 80 80 [bg, windMarker, boatMarker, windAngleText]

--renderControls : Wind -> Boat -> (Int,Int) -> Element
--renderControls wind boat (w,h) =
--  let wheel = renderControlWheel wind boat
--      fmt = centered . monospace . toText
--      windOriginText = wind.origin |> show |> fmt
--  in 
--      flow down [windOriginText, wheel] |> opacity 0.8 |> container w h topRight

renderForBoat : (Int,Int) -> GameState -> Boat -> [Boat] -> Element
renderForBoat (w,h) gameState boat otherBoats =
  let dims = floatify (w,h)
      (w',h') = dims
      race = renderRace gameState boat otherBoats dims
      --controls = renderControls gameState.wind boat (w,h)
      bg = rect w' h' |> filled (rgb 239 210 121)
  in 
      layers [collage w h [bg, race]]
              --asText (gameState.boat.passedGates) ]

render : (Int,Int) -> GameState -> Element
render (w,h) gameState =
  case gameState.otherBoat of
    Just otherBoat -> let w' = (div w 2) - 2
                          r1 = renderForBoat (w',h) gameState gameState.boat [otherBoat]
                          r2 = renderForBoat (w',h) gameState otherBoat [gameState.boat] 
                      in flow left [r1, spacer 4 1, r2]
    Nothing        -> renderForBoat (w,h) gameState gameState.boat []
