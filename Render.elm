module Render where

import Core (..)
import Geo (..)
import Game (..)

{-- Part 4: Display the game --------------------------------------------------

How should the GameState be displayed to the user?

Task: redefine `render` to use the GameState you defined in part 2.

------------------------------------------------------------------------------}

renderGate : Gate -> Float -> Bool -> Form
renderGate ({y, width}) markRadius isNext =
  let left = (-width / 2, y)
      right = (width / 2, y)
      line = segment left right |> traced (dotted orange)
      markStyle = if isNext then filled orange else filled white
      leftMark = circle markRadius |> markStyle |> move left
      rightMark = circle markRadius |> markStyle |> move right
      marks = [leftMark, rightMark]
  in
    if isNext then group (line :: marks) else group marks

renderBoat : Boat -> Form
renderBoat boat =
  image 8 19 "/icon-boat-white.png" |> toForm
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

renderRace : GameState -> Form
renderRace gameState =
  let course = gameState.course
      ng = nextGate gameState.boat course.laps
      start = renderGate course.downwind course.markRadius (ng == Just Downwind)
      upwind = renderGate course.upwind course.markRadius (ng == Just Upwind)
      bounds = renderBounds gameState.bounds
      boatPic = renderBoat gameState.boat
      equalityLine = renderEqualityLine gameState.boat.position gameState.wind.origin
  in move (neg gameState.center) (group [bounds, start, upwind, boatPic])

renderWind : GameState -> (Float,Float) -> Form
renderWind ({boat, wind}) (w,h) =
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
      text = boat.windAngle |> abs |> asText |> toForm
      center = (w/2 - 50, h/2 - 50)
  in group [bg, windMarker, boatMarker, text] |> move center |> alpha 0.8

render : (Int,Int) -> GameState -> Element
render (w,h) gameState =
  let (w',h') = floatify (w,h)
      race = renderRace gameState
      wind = renderWind gameState (w',h')
      bg = rect w' h' |> filled (rgb 239 210 121)
  in layers [ collage w h [bg, race, wind],
              asText (gameState.boat.passedGates) ]
