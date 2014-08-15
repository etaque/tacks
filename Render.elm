module Render where

import Core (..)
import Geo (..)
import Game (..)
import Debug

{-- Part 4: Display the game --------------------------------------------------

How should the GameState be displayed to the user?

Task: redefine `render` to use the GameState you defined in part 2.

------------------------------------------------------------------------------}

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
      distance = round (abs (gate.y - h/2 - cy)) |> asText |> toForm
  in 
    case (over, under) of
      (True, _) -> 
        let m = polygon [(0,0),(-c,-c),(c,-c)] |> markStyle
                                               |> move (-cx,(h/2))
            d = distance |> move (-cx, h/2 - c*3) 
        in
          group [m, d]

      (_, True) -> polygon [(0,0),(-c,c),(c,c)]   |> markStyle
                                                  |> move (-cx,(-h/2))
      (_, _)    -> group []

renderBoat : Boat -> Bool -> Form
renderBoat boat isMain =
  let icon = if isMain then "/icon-boat-white.png" else "/boat.png"
  in
    image 8 19 icon |> toForm
                    |> rotate (toRadians (boat.direction + 90))
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

renderRace : GameState -> Boat -> [Boat] -> (Float,Float) -> Form
renderRace gameState boat otherBoats dims =
  let course = gameState.course
      nextGate = findNextGate boat course.laps
      downwindGate = renderGate course.downwind nextGate
      downwindHiddenGate = renderHiddenGate course.downwind dims boat.center nextGate
      upwindGate = renderGate course.upwind nextGate
      upwindHiddenGate = renderHiddenGate course.upwind dims boat.center nextGate
      bounds = renderBounds gameState.bounds
      boatPic = renderBoat boat True
      otherBoatsPics = map (\b -> renderBoat b False) otherBoats |> group
      equalityLine = renderEqualityLine boat.position gameState.wind.origin
      relativeToCenter = (group [bounds, downwindGate, upwindGate, otherBoatsPics, boatPic]) |> move (neg boat.center)
      absolute = group [upwindHiddenGate, downwindHiddenGate]
  in  group [relativeToCenter, absolute]

renderControlWheel : Wind -> Boat -> Element
renderControlWheel wind boat =
  let bg = circle 30 |> filled white
      windAngle = toRadians wind.origin
      windMarker = polygon [(0,4),(-4,-4),(4,-4)] 
                |> filled white 
                |> rotate (windAngle + pi/2)
                |> move (fromPolar (34, windAngle))
      boatAngle = toRadians boat.direction
      boatMarker = polygon [(0,4),(-4,-4),(4,-4)] 
                |> filled black
                |> rotate (boatAngle - pi/2)
                |> move (fromPolar (26, boatAngle))
      fmt = if boat.controlMode == FixedWindAngle then line Under else id
      windAngleText = boat.windAngle |> abs |> show |> toText |> monospace |> fmt |> centered |> toForm
  in
      collage 80 80 [bg, windMarker, boatMarker, windAngleText]

renderControls : Wind -> Boat -> (Int,Int) -> Element
renderControls wind boat (w,h) =
  let wheel = renderControlWheel wind boat
      fmt = centered . monospace . toText
      windOriginText = wind.origin |> show |> fmt
  in 
      flow down [windOriginText, wheel] |> opacity 0.8 |> container w h topRight

renderForBoat : (Int,Int) -> GameState -> Boat -> [Boat] -> Element
renderForBoat (w,h) gameState boat otherBoats =
  let dims = floatify (w,h)
      (w',h') = dims
      race = renderRace gameState boat otherBoats dims
      controls = renderControls gameState.wind boat (w,h)
      bg = rect w' h' |> filled (rgb 239 210 121)
  in 
      layers [collage w h [bg, race], controls]
              --asText (gameState.boat.passedGates) ]

render : (Int,Int) -> GameState -> Element
render (w,h) gameState =
  case gameState.otherBoat of
    Just otherBoat -> let w' = (div w 2) - 2
                          r1 = renderForBoat (w',h) gameState gameState.boat [otherBoat]
                          r2 = renderForBoat (w',h) gameState otherBoat [gameState.boat] 
                      in flow left [r1, spacer 4 1, r2]
    Nothing        -> renderForBoat (w,h) gameState gameState.boat []
