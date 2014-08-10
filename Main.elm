module GameSkeleton where

import Keyboard
import Mouse
import Window
import Time
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
type Drags = Maybe (Int, Int)
type UserInput = (UserArrows, Bool, Bool, Drags, (Int,Int))
type GameClock = (Time, Float)

userInput : Signal UserInput
userInput = lift5 (,,,,) Keyboard.arrows Keyboard.shift Keyboard.space (Drag.lastPosition (20 * Time.millisecond)) Mouse.position

type Input = { clock: GameClock, userInput: UserInput }

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

data WindSide = Babord | Tribord | Neutral

type Boat = { position: Point, direction: Int, velocity: Float, windAngle: Int, tackTarget: Maybe Int, windSide: WindSide, wake: [Point] }

boat : Boat
boat = { position = (200,-200), direction = 0, velocity = 0, windAngle = 0, tackTarget = Nothing, windSide = Neutral, wake = [] }

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

polarVelocity : Int -> Float
polarVelocity delta =
  let x = toFloat(delta)
      v = 1.084556812 * (10^ -6) * (x^3) - 1.058704484 * (10^ -3) * (x^2) +
        0.195782694 * x - 7.136475544 * (10^ -1)
  in if v < 0 then v else v

defineTackTarget : Boat -> Wind -> Int
defineTackTarget boat wind =
  let wa = boat.windAngle
      d = boat.direction
      w = wind.origin
  in
    case wa of
      0   -> d
      180 -> d
      _   -> if ensure360 (d + w) > 180 
               then w + wa |> ensure360 
               else w - wa |> ensure360

centerGame : GameState -> Maybe (Int,Int) -> (Int,Int) -> Point
centerGame gameState drag (x,y) =
  case drag of
    Nothing      -> gameState.center 
    Just (x',y') -> let dx = (x - x')
                        dy = (y' - y)
                    in
                      G.sub (floatify (dx,dy)) gameState.center
    
keysStep : UserInput -> GameState -> GameState
keysStep (arrows, shift, space, drag, mouse) gameState =
  let boat = gameState.boat
      newWindSide = defineWindSide boat.direction boat.windAngle gameState.wind.origin
      newTackTarget = 
        if arrows.x /= 0 
          then Nothing
          else case (boat.tackTarget, space) of
            (Just target, _) -> if target == boat.direction then Nothing else boat.tackTarget
            (Nothing, True) -> Just (defineTackTarget boat gameState.wind)
            (Nothing, False) -> boat.tackTarget
      turn = case (newTackTarget, shift) of 
        (Just target, _) -> if ensure360 (boat.direction - target) > 180 then 2 else -2
        (Nothing, True)  -> arrows.x
        (Nothing, False) -> arrows.x * 2
      newDirection = ensure360 <| boat.direction + turn
      newBoat = { boat | direction <- newDirection,
                         windSide <- newWindSide,
                         tackTarget <- newTackTarget }
      center = centerGame gameState drag mouse
  in { gameState | boat <- newBoat,
                   center <- center }

inBounds : Point -> (Point,Point) -> Bool
inBounds p box =
  let ((xMax, yMax), (xMin, yMin)) = box
      (x, y) = p
  in x > xMin && x < xMax && y > yMin && y < yMax

currentWindOrigin : Time -> Int
currentWindOrigin timestamp = round (cos (inSeconds timestamp / 10) * 10)

moveBoat : Point -> Time -> Float -> Int -> Point
moveBoat (x,y) delta velocity direction = 
  let angle = toRadians direction
      x' = x + delta * velocity * cos angle
      y' = y + delta * velocity * sin angle
  in (x',y')

boatVelocity : Int -> Float -> Float
boatVelocity windAngle previousVelocity =
  let v = polarVelocity(windAngle) * 5
      delta = v - previousVelocity
  in previousVelocity + delta * 0.02

defineWindSide : Int -> Int -> Int -> WindSide
defineWindSide direction windAngle windOrigin =
  if direction - windAngle == windOrigin 
    then Babord
    else Tribord

moveStep : GameClock -> GameState -> GameState
moveStep (timestamp, delta) ({wind, boat} as gameState) =
  let {position, direction, velocity, windAngle, wake} = boat
      currentWind = { wind | origin <- currentWindOrigin timestamp }
      newWindAngle = angleToWind direction currentWind.origin
      newVelocity = boatVelocity newWindAngle velocity
      nextPosition = moveBoat position delta newVelocity direction
      isInBounds = inBounds nextPosition gameState.bounds
      newPosition = if isInBounds then nextPosition else position
      newWake = take 50 (newPosition :: wake)
      newBoat = { boat | position <- newPosition,
                         velocity <- if isInBounds then newVelocity else 0,
                         windAngle <- newWindAngle,
                         wake <- newWake }
  in { gameState | boat <- newBoat, wind <- currentWind }

stepGame : Input -> GameState -> GameState
stepGame input gameState =
  keysStep input.userInput <| moveStep input.clock gameState


{-- Part 4: Display the game --------------------------------------------------

How should the GameState be displayed to the user?

Task: redefine `render` to use the GameState you defined in part 2.

------------------------------------------------------------------------------}

renderGate : Gate -> Bool -> Form
renderGate gate isNext =
  let style = if isNext then solid white else dotted grey
  in traced style <| segment gate.left gate.right

renderBoat : Boat -> Form
renderBoat boat =
  image 8 19 "/icon-boat-white.png" |> toForm
                                    |> rotate (toRadians (boat.direction + 90))
                                    |> move boat.position

renderWake : [Point] -> Form
renderWake wake =
  path wake |> traced (solid (rgba 255 255 255 0.3))

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
  let start = renderGate gameState.course.downwind True
      upwind = renderGate gameState.course.upwind False
      bounds = renderBounds gameState.bounds
      boatPic = renderBoat gameState.boat
      boatWake = renderWake gameState.boat.wake
      equalityLine = renderEqualityLine gameState.boat.position gameState.wind.origin
  in move (G.neg gameState.center) (group [bounds, start, upwind, boatWake, boatPic])


render : (Int,Int) -> GameState -> Element
render (w,h) gameState =
  let race = renderRace gameState
      bg = rect (toFloat w) (toFloat h) |> filled (rgb 239 210 121)
  in layers [ collage w h [bg, race],
              asText (gameState.boat.windAngle) ]

{-- That's all folks! ---------------------------------------------------------

The following code puts it all together and shows it on screen.

------------------------------------------------------------------------------}

clock = timestamp (inSeconds <~ fps 30)
input = sampleOn clock (lift2 Input clock userInput)

gameState = foldp stepGame defaultGame input

main = lift2 render Window.dimensions gameState
