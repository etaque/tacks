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
type KeyboardInput = { arrows: UserArrows, shift: Bool, space: Bool, aKey: Bool, dKey: Bool }
type MouseInput = { drag: Maybe (Int,Int), mouse: (Int,Int) }
type GameClock = (Time, Float)

mouseInput : Signal MouseInput
mouseInput = lift2 MouseInput (Drag.lastPosition (20 * Time.millisecond)) Mouse.position

keyboardInput : Signal KeyboardInput
keyboardInput = lift5 KeyboardInput 
  Keyboard.arrows Keyboard.shift Keyboard.space (Keyboard.isDown 65) (Keyboard.isDown 68)

port log : Signal [Int]
port log = (Keyboard.keysDown)

type Input = { clock: GameClock, keyboardInput: KeyboardInput, mouseInput: MouseInput }

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
data ControlMode = FixedDirection | FixedWindAngle

type Boat = { position: Point, direction: Int, velocity: Float, windAngle: Int, 
              controlMode: ControlMode, tackTarget: Maybe Int, windSide: WindSide, wake: [Point] }

boat : Boat
boat = { position = (200,-200), direction = 0, velocity = 0, windAngle = 0, 
         controlMode = FixedDirection, tackTarget = Nothing, windSide = Neutral, wake = [] }

type Wind = { origin: Int }

wind : Wind
wind = { origin = 0 }

type Gate = { left: Point, right: Point }

startLine : Gate
startLine = { left = (-50, -100), right = (50, -100) }

upwindGate : Gate
upwindGate = { left = (-50, 800), right = (50, 800) }

type Course = { upwind: Gate, downwind: Gate, laps: Int }

course : Course
course = { upwind = upwindGate, downwind = startLine, laps = 2 }

type GameState = { wind: Wind, boat: Boat, course: Course, bounds: (Point, Point), center: Point }

defaultGame : GameState
defaultGame = { wind = wind, boat = boat, course = course,
                bounds = ((700,1000), (-700,-300)), center = (0,0) }



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
  let delta = boatDirection - windOrigin
  in 
    if | delta > 180   -> delta - 360
       | delta <= -180 -> delta + 360
       | otherwise     -> delta

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
    ensure360 (w - wa)

mouseStep : MouseInput -> GameState -> GameState
mouseStep ({drag, mouse} as mouseInput) gameState =
  let center = case drag of
    Just (x',y') -> let (x,y) = mouse in G.sub (floatify (x - x', y' - y)) gameState.center
    Nothing      -> gameState.center 
  in
    { gameState | center <- center }


keysStep : KeyboardInput -> GameState -> GameState
keysStep ({arrows, shift, space, aKey, dKey} as keyboardInput) ({wind, boat} as gameState) =
  let newWindSide = if boat.windAngle > 0 then Babord else Tribord
      newControlMode = case (aKey, dKey, boat.controlMode) of
        (True, _, FixedDirection) -> FixedWindAngle
        (_, True, FixedWindAngle) -> FixedDirection
        (_, _, _)                 -> boat.controlMode
      -- calcul de la cible du virement, si nécessaire
      newTackTarget = 
        if arrows.x /= 0 -- annule le virement
          then Nothing
          else case (boat.tackTarget, space) of
            -- si direction cible atteinte, on arrête le virement
            (Just target, _) -> if target == boat.direction then Nothing else boat.tackTarget
            -- si touche espace pressée, on défini la cible
            (Nothing, True)  -> Just (defineTackTarget boat wind)
            -- sinon, pas de cible
            (Nothing, False) -> Nothing
      -- calcul de la modification de direction
      turn = case (newTackTarget, newControlMode, shift, arrows.x) of 
        -- virement en cours
        (Just target, _, _, _) -> if ensure360 (boat.direction - target) > 180 then 2 else -2
        -- pas de virement ni de touche flèche, donc contrôle auto
        (Nothing, _, _, 0)     -> case newControlMode of
                                    FixedDirection -> 0
                                    FixedWindAngle -> (wind.origin + boat.windAngle) - boat.direction
        -- changement de direction via touche flèche
        (Nothing, _, True,  _) -> arrows.x
        (Nothing, _, False, _) -> arrows.x * 2
      newDirection = ensure360 <| boat.direction + turn
      newWindAngle = angleToWind newDirection wind.origin
  in 
    { gameState | boat <- { boat | direction <- newDirection,
                                   windSide <- newWindSide,
                                   windAngle <- newWindAngle,
                                   controlMode <- newControlMode,
                                   tackTarget <- newTackTarget }}

inBounds : Point -> (Point,Point) -> Bool
inBounds p box =
  let ((xMax, yMax), (xMin, yMin)) = box
      (x, y) = p
  in x > xMin && x < xMax && y > yMin && y < yMax

moveBoat : Point -> Time -> Float -> Int -> Point
moveBoat (x,y) delta velocity direction = 
  let angle = toRadians direction
      x' = x + delta * velocity * cos angle
      y' = y + delta * velocity * sin angle
  in (x',y')

boatVelocity : Int -> Float -> Float
boatVelocity windAngle previousVelocity =
  let v = polarVelocity(abs windAngle) * 5
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
      newVelocity = boatVelocity boat.windAngle velocity
      nextPosition = moveBoat position delta newVelocity direction
      isInBounds = inBounds nextPosition gameState.bounds
      newPosition = if isInBounds then nextPosition else position
      newWake = take 200 (newPosition :: wake)
      newBoat = { boat | position <- newPosition,
                         velocity <- if isInBounds then newVelocity else 0,
                         wake <- newWake }
  in { gameState | boat <- newBoat }

windStep : GameClock -> GameState -> GameState
windStep (timestamp, _) ({wind, boat} as gameState) =
  let o1 = cos (inSeconds timestamp / 10) * 15
      o2 = cos (inSeconds timestamp / 5) * 5
      newOrigin = round (o1 + o2)
      newWind = { wind | origin <- newOrigin }
  in { gameState | wind <- newWind }


stepGame : Input -> GameState -> GameState
stepGame input gameState =
  mouseStep input.mouseInput <| keysStep input.keyboardInput <| moveStep input.clock <| windStep input.clock gameState


{-- Part 4: Display the game --------------------------------------------------

How should the GameState be displayed to the user?

Task: redefine `render` to use the GameState you defined in part 2.

------------------------------------------------------------------------------}

renderGate : Gate -> Bool -> Form
renderGate gate isNext =
  let style = if isNext then solid white else dotted grey
      line = segment gate.left gate.right |> traced style
      leftMark = circle 5 |> filled white |> move gate.left
      rightMark = circle 5 |> filled white |> move gate.right
  in
    group [line, leftMark, rightMark]

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

renderWind : GameState -> (Float,Float) -> Form
renderWind ({boat, wind}) (w,h) =
  let bg = circle 30 |> filled white
      windAngle = toRadians wind.origin
      windMarker = polygon [(0,4),(-4,-4),(4,-4)] 
                |> filled red 
                |> rotate (windAngle + pi/2)
                |> move (fromPolar (34, windAngle))
      boatAngle = toRadians boat.direction
      boatMarker = polygon [(0,4),(-4,-4),(4,-4)] 
                |> filled black
                |> rotate (boatAngle - pi/2)
                |> move (fromPolar (26, boatAngle))
      text = asText wind.origin
      center = (w/2 - 50, h/2 - 50)
  in move center (group [bg, windMarker, boatMarker])

render : (Int,Int) -> GameState -> Element
render (w,h) gameState =
  let (w',h') = floatify (w,h)
      race = renderRace gameState
      wind = renderWind gameState (w',h')
      bg = rect w' h' |> filled (rgb 239 210 121)
  in layers [ collage w h [bg, race, wind],
              asText (gameState.boat.windAngle) ]

{-- That's all folks! ---------------------------------------------------------

The following code puts it all together and shows it on screen.

------------------------------------------------------------------------------}

clock = timestamp (inSeconds <~ fps 30)
input = sampleOn clock (lift3 Input clock keyboardInput mouseInput)

gameState = foldp stepGame defaultGame input

main = lift2 render Window.dimensions gameState
