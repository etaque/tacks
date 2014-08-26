module Render.Relative where

import Core (..)
import Geo (..)
import Game (..)
import String
import Text

colors = { seaBlue = rgb 10 105 148,
           sand = rgb 239 210 121 }

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
  in rect w h |> filled colors.seaBlue
              |> move (cw, ch)

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

renderIsland : Island -> Form
renderIsland {location,radius} =
  let --grad = radial (0,0) (radius - 15) (0,0) radius [(0, colors.sand), (1, colors.seaBlue)]
      ground = circle radius |> filled colors.sand
      --palmWidth = minimum [round radius, 100]
      --palm = fittedImage palmWidth palmWidth "/assets/images/palmtree.png" |> toForm --|> move (0, island.radius/5)
      --palm = image palmWidth palmWidth "/assets/images/palmtree.png" |> toForm |> move (0, (toFloat palmWidth) / 2)
  in group [ground] |> move location

renderIslands : GameState -> Form
renderIslands gameState =
  group (map renderIsland gameState.course.islands)

renderLaylines : Boat -> Course -> Form
renderLaylines boat course = 
  let upwindVmgAngleR = toRadians upwindVmg
      upwindMark = course.upwind
      (left,right) = getGateMarks upwindMark
      windAngleR = toRadians boat.windOrigin

      leftLL = add left (fromPolar (500, windAngleR + upwindVmgAngleR - pi))

      l1 = segment left leftLL |> traced (solid white)
  in group [l1] |> alpha 0.3


renderRelative : GameState -> Boat -> [Opponent] -> Form
renderRelative gameState boat opponents =
  let course = gameState.course
      nextGate = findNextGate boat course.laps
      downwindGate = renderGate course.downwind course.markRadius nextGate
      upwindGate = renderGate course.upwind course.markRadius nextGate
      bounds = renderBounds gameState.course.bounds
      boatPic = renderBoat boat
      opponentsPics = map (\b -> renderOpponent b) opponents |> group
      equalityLine = renderEqualityLine boat.position gameState.wind.origin
      islands = renderIslands gameState
      gusts = renderGusts gameState.wind
      --laylines = renderLaylines boat gameState.course
  in
      (group [bounds, islands, gusts, downwindGate, upwindGate, opponentsPics, equalityLine, boatPic]) 
        |> move (neg boat.center)

