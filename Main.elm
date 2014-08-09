module GameSkeleton where

import Keyboard
import Window
import Set as S
import Drag as Drag
import Geo as G

{-- Part 1: Model the user input ----------------------------------------------

What information do you need to represent all relevant user input?

Task: Redefine `UserInput` to include all of the information you need.
      Redefine `userInput` to be a signal that correctly models the user
      input as described by `UserInput`.

------------------------------------------------------------------------------}

type UserArrows = { x:Int, y:Int }
type Drops = Maybe ((Int, Int), (Int, Int))
type UserInput = (UserArrows, Drops)

userInput : Signal UserInput
userInput = lift2 (,) Keyboard.arrows Drag.drop

type Input = { timeDelta:Float, userInput:UserInput }

floatify (x,y) = (toFloat x, toFloat y)


{-- Part 2: Model the game ----------------------------------------------------

What information do you need to represent the entire game?

Tasks: Redefine `GameState` to represent your particular game.
       Redefine `defaultGame` to represent your initial game state.

For example, if you want to represent many objects that just have a position,
your GameState might just be a list of coordinates and your default game might
be an empty list (no objects at the start):

    type GameState = { objects : [(Float,Float)] }
    defaultGame = { objects = [] }

------------------------------------------------------------------------------}

type Point = G.Point

type Boat = { position: Point, direction: Int, velocity: Float, windAngle: Int, wake: [Point] }

boat : Boat
boat = { position = (200,-200), direction = 0, velocity = 0, windAngle = 0, wake = [] }

type Wind = { origin: Int }

wind : Wind
wind = { origin = 0 }

type Gate = { left: Point, right: Point }

startLine : Gate
startLine = { left = (-50, -100), right = (50, -100) }

upwindGate : Gate
upwindGate = { left = (-50, 300), right = (50, 300) }

type Course = { upwind: Gate, downwind: Gate, laps: Int }

course : Course
course = { upwind = upwindGate, downwind = startLine, laps = 2 }

type GameState = { wind: Wind, boat: Boat, course: Course, bounds: (Point, Point), center: Point }

defaultGame : GameState
defaultGame = { wind = wind, boat = boat, course = course,
                bounds = ((500,1000), (-500,-300)), center = (0,0) }



{-- Part 3: Update the game ---------------------------------------------------

How does the game step from one state to another based on user input?

Task: redefine `stepGame` to use the UserInput and GameState
      you defined in parts 1 and 2. Maybe use some helper functions
      to break up the work, stepping smaller parts of the game.

------------------------------------------------------------------------------}

type Arrows = { x:Int, y:Int }

ensure360 : Int -> Int
ensure360 val = (val + 360) `mod` 360

angleToWind : Int -> Int -> Int
angleToWind boatDirection windOrigin = 
  let delta = windOrigin - boatDirection
      delta360 = if | delta > 180   -> delta - 360
                    | delta <= -180 -> delta + 360
                    | otherwise     -> delta
  in abs delta360

toRadians : Int -> Float
toRadians deg = radians (toFloat(90 - deg) * pi / 180)
--toRadians deg = degrees(toFloat(deg))

polarVelocity : Int -> Float
polarVelocity delta =
  let x = toFloat(delta)
      v = 1.084556812 * (10^ -6) * (x^3) - 1.058704484 * (10^ -3) * (x^2) + 
        0.195782694 * x - 7.136475544 * (10^ -1)
  in if v < 0 then v else v

keysStep : UserInput -> GameState -> GameState
keysStep (arrows, drops) gameState =
    let boat = gameState.boat
        newBoat = { boat | direction <- ensure360 <| boat.direction + arrows.x}
        center = case drops of
          Just (from, to) -> G.sub (floatify from) (floatify to)
          Nothing         -> gameState.center
    in { gameState | boat <- newBoat,
                     center <- center }

inBounds : Point -> (Point,Point) -> Bool
inBounds p box =
  let ((xMax, yMax), (xMin, yMin)) = box
      (x, y) = p
  in x > xMin && x < xMax && y > yMin && y < yMax

moveStep : Time -> GameState -> GameState
moveStep delta ({wind, boat} as gameState) =
    let {position, direction, velocity, windAngle, wake} = boat
        (x,y) = position
        newWindAngle = angleToWind direction wind.origin
        newVelocity = polarVelocity(newWindAngle) * 5
        newVelocityWithInertia = velocity + (newVelocity - velocity) * 0.02
        angle = toRadians direction
        x' = x + delta * newVelocityWithInertia * cos angle
        y' = y + delta * newVelocityWithInertia * sin angle
        isInBounds = inBounds (x',y') gameState.bounds
        newPosition = if isInBounds then (x',y') else (x,y)
        newWake = take 50 (newPosition :: wake)
        newBoat = { boat | position <- newPosition,
                           velocity <- if isInBounds then newVelocityWithInertia else 0,
                           windAngle <- newWindAngle,
                           wake <- newWake }
    in { gameState | boat <- newBoat }

stepGame : Input -> GameState -> GameState
stepGame input gameState =
  keysStep input.userInput <| moveStep input.timeDelta gameState


{-- Part 4: Display the game --------------------------------------------------

How should the GameState be displayed to the user?

Task: redefine `render` to use the GameState you defined in part 2.

------------------------------------------------------------------------------}

renderGate : Gate -> Bool -> Point -> Form
renderGate gate isNext center = 
  let left = G.sub center gate.left
      right = G.sub center gate.right
      style = if isNext then solid white else dotted grey
  in traced style <| segment left right

renderBoat : Boat -> Point -> Form
renderBoat boat center =
  image 8 19 "/icon-boat-white.png" |> toForm 
                                    |> rotate (toRadians (boat.direction + 90))
                                    |> move (G.sub center boat.position)

renderWake : [Point] -> Point -> Form
renderWake wake center =
  path (map (\p -> G.sub center p) wake) |> traced (solid (rgba 255 255 255 0.3))

renderBounds : (Point, Point) -> Point -> Form
renderBounds box center =
  let (ne,sw) = box
      w = fst ne - fst sw
      h = snd ne - snd sw
      cw = (fst ne + fst sw) / 2
      ch = (snd ne + snd sw) / 2
  in rect w h |> filled (rgb 10 105 148) 
              |> move (G.sub center (cw, ch))

render : (Int,Int) -> GameState -> Element
render (w,h) gameState = 
  --let center = centerForBoat (w,h) gameState.boat.position
  let start = renderGate gameState.course.downwind True gameState.center
      upwind = renderGate gameState.course.upwind False gameState.center
      boatPic = renderBoat gameState.boat gameState.center
      bounds = renderBounds gameState.bounds gameState.center
      wake = renderWake gameState.boat.wake gameState.center
      bg = rect (toFloat w) (toFloat h) |> filled (rgb 239 210 121)
  in layers [ collage w h [bg, bounds, start, upwind, wake, boatPic],
              asText gameState ]

{-- That's all folks! ---------------------------------------------------------

The following code puts it all together and shows it on screen.

------------------------------------------------------------------------------}

delta = inSeconds <~ fps 30
input = sampleOn delta (lift2 Input delta userInput)

gameState = foldp stepGame defaultGame input

main = lift2 render Window.dimensions gameState