module Steps where

import Inputs (..)
import Game (..)
import Geo (..)
import Core (..)

import Debug

{-- Part 3: Update the game ---------------------------------------------------

How does the game step from one state to another based on user input?

Task: redefine `stepGame` to use the UserInput and GameState
      you defined in parts 1 and 2. Maybe use some helper functions
      to break up the work, stepping smaller parts of the game.

------------------------------------------------------------------------------}

mouseStep : MouseInput -> GameState -> GameState
mouseStep ({drag, mouse} as mouseInput) gameState =
  let boat = gameState.boat
      center = case drag of
        Just (x',y') -> let (x,y) = mouse in sub (floatify (x - x', y' - y)) boat.center
        Nothing      -> boat.center 
  in
    { gameState | boat <- { boat | center <- center } }

tackTargetReached : Boat -> Maybe Int -> Bool
tackTargetReached boat targetMaybe = 
  case (targetMaybe, boat.controlMode) of
    (Just target, FixedWindAngle) -> target == boat.windAngle
    (Just target, FixedDirection) -> target == boat.direction
    (Nothing, _)                  -> False

getTackTarget : Boat -> Wind -> Bool -> Maybe Int
getTackTarget boat wind spaceKey =
  case (boat.tackTarget, spaceKey) of
    -- target en cours
    (Just _, _) -> 
      -- si direction cible atteinte, on arrête le virement
      if tackTargetReached boat boat.tackTarget then Nothing else boat.tackTarget
    -- si touche espace pressée, on défini la cible
    (Nothing, True) -> 
      case boat.controlMode of
        FixedWindAngle -> Just -boat.windAngle
        FixedDirection -> Just (ensure360 (wind.origin - boat.windAngle))
    -- sinon, pas de cible
    (Nothing, False) -> Nothing



getTurn : Maybe Int -> Boat -> Wind -> UserArrows -> Int 
getTurn tackTarget boat wind arrows =
  case (tackTarget, boat.controlMode, arrows.x, arrows.y) of 
    -- virement en cours
    (Just target, _, _, _) -> 
      case boat.controlMode of 
        FixedDirection -> 
          let maxTurn = minimum [2, (abs (boat.direction - target))]
          in
            if ensure360 (boat.direction - target) > 180 then maxTurn else -maxTurn
        FixedWindAngle -> 
          let maxTurn = minimum [2, (abs (boat.windAngle - target))]
          in
            if target > 90 || (target < 0 && target >= -90) then -maxTurn else maxTurn
    -- pas de virement ni de touche flèche, donc contrôle auto
    (Nothing, FixedDirection, 0, 0) -> 0
    (Nothing, FixedWindAngle, 0, 0) -> (wind.origin + boat.windAngle) - boat.direction
    -- changement de direction via touche flèche
    (Nothing, _, x, y) -> if y < 0 then x else x * 3

keysForBoatStep : KeyboardInput -> Wind -> Boat -> Boat
keysForBoatStep ({arrows, lockAngle, tack}) wind boat =
  let forceTurn = arrows.x /= 0 
      tackTarget = if forceTurn then Nothing else getTackTarget boat wind tack
      turn = getTurn tackTarget boat wind arrows
      direction = ensure360 <| boat.direction + turn
      windAngle = angleToWind direction wind.origin
      turnedBoat = { boat | direction <- direction,
                            windAngle <- windAngle }
      tackTargetAfterTurn = if tackTargetReached turnedBoat tackTarget then Nothing else tackTarget
      controlMode = if | forceTurn -> FixedDirection
                       | arrows.y > 0 -> FixedWindAngle
                       | otherwise -> turnedBoat.controlMode
  in 
    { turnedBoat | controlMode <- controlMode,
                   tackTarget <- tackTargetAfterTurn }

keysStep : KeyboardInput -> KeyboardInput -> GameState -> GameState
keysStep keyboardInput otherKeyboardInput gameState =
  let boatUpdated = keysForBoatStep keyboardInput gameState.wind gameState.boat
      otherBoatUpdated = mapMaybe (keysForBoatStep otherKeyboardInput gameState.wind) gameState.otherBoat
  in 
    { gameState | boat <- boatUpdated, otherBoat <- otherBoatUpdated }

gatePassedInX : Gate -> (Point,Point) -> Bool
gatePassedInX gate ((x,y),(x',y')) =
  let a = (y - y') / (x - x')
      b = y - a * x
      xGate = (gate.y - b) / a
  in
    (abs xGate) <= gate.width / 2

gatePassedFromNorth : Gate -> (Point,Point) -> Bool
gatePassedFromNorth gate (p1,p2) =
  (snd p1) > gate.y && (snd p2) <= gate.y && (gatePassedInX gate (p1,p2))

gatePassedFromSouth : Gate -> (Point,Point) -> Bool
gatePassedFromSouth gate (p1,p2) =
  (snd p1) < gate.y && (snd p2) >= gate.y && (gatePassedInX gate (p1,p2))

getPassedGates : Boat -> Time -> Course -> (Point,Point) -> [(GateLocation,Time)]
getPassedGates boat timestamp ({upwind, downwind, laps}) step =
  case (findNextGate boat course.laps, isEmpty boat.passedGates) of
    -- ligne de départ
    (_, True)          -> if | gatePassedFromSouth downwind step -> (Downwind, timestamp) :: boat.passedGates 
                             | otherwise                         -> boat.passedGates
    -- bouée au vent
    (Just Upwind, _)   -> if | gatePassedFromSouth upwind step   -> (Upwind, timestamp) :: boat.passedGates 
                             | gatePassedFromSouth downwind step -> tail boat.passedGates
                             | otherwise                         -> boat.passedGates
    -- bouée sous le vent
    (Just Downwind, _) -> if | gatePassedFromNorth downwind step -> (Downwind, timestamp) :: boat.passedGates 
                             | gatePassedFromNorth upwind step   -> tail boat.passedGates 
                             | otherwise                         -> boat.passedGates
    -- arrivée déjà franchie
    (Nothing, _)       -> boat.passedGates

getGatesMarks : Course -> [Point]
getGatesMarks course =
  [
    (course.upwind.width / -2, course.upwind.y),
    (course.upwind.width / 2, course.upwind.y),
    (course.downwind.width / -2, course.downwind.y),
    (course.downwind.width / 2, course.downwind.y)
  ]

isStuck : Point -> GameState -> Bool
isStuck p gameState =
  let gatesMarks = getGatesMarks gameState.course
      stuckOnMark = any (\m -> distance m p <= gameState.course.markRadius) gatesMarks
      outOfBounds = not (inBox p gameState.bounds)
      onIsland = any (\i -> distance i.location p <= i.radius) gameState.islands
  in 
    outOfBounds || stuckOnMark || onIsland

getCenterAfterMove : Point -> Point -> Point -> (Float,Float) -> (Point)
getCenterAfterMove (x,y) (x',y') (cx,cy) (w,h) =
  let refocus n n' cn dn margin = 
        let min = cn - (dn / 2) + margin
            max = cn + (dn / 2) - margin
        in
          if | n < min || n > max -> cn
             | n' < min           -> cn - (n - n')
             | n' > max           -> cn + (n' - n)
             | otherwise          -> cn
  in
    (refocus x x' cx w (w * 0.2), refocus y y' cy h (h * 0.4))

moveBoat : GameClock -> GameState -> (Int,Int) -> Boat -> Boat
moveBoat (timestamp, delta) gameState dimensions boat =
  let {position, direction, velocity, windAngle, passedGates} = boat
      newVelocity = boatVelocity boat.windAngle velocity
      nextPosition = movePoint position delta newVelocity direction
      stuck = isStuck nextPosition gameState
      newPosition = if stuck then position else nextPosition
      newPassedGates = if maybe False (\c -> c <= 0) gameState.countdown
        then getPassedGates boat timestamp gameState.course (position, newPosition)
        else boat.passedGates
      newCenter = getCenterAfterMove position newPosition boat.center (floatify dimensions)
  in
      { boat | position <- newPosition,
               velocity <- if stuck then 0 else newVelocity,
               center <- newCenter,
               passedGates <- newPassedGates }

moveStep : GameClock -> (Int,Int) -> GameState -> GameState
moveStep clock (w,h) gameState =
  let dims = if (isJust gameState.otherBoat) then (div w 2, h) else (w,h)
      boatMoved = moveBoat clock gameState dims gameState.boat
      otherBoatMoved = mapMaybe (moveBoat clock gameState dims) gameState.otherBoat
  in
    { gameState | boat <- boatMoved,
                  otherBoat <- otherBoatMoved }

windStep : GameClock -> GameState -> GameState
windStep (timestamp, _) ({wind, boat} as gameState) =
  let o1 = cos (inSeconds timestamp / 10) * 15
      o2 = cos (inSeconds timestamp / 5) * 5
      newOrigin = round (o1 + o2) |> ensure360
      newWind = { wind | origin <- newOrigin }
  in { gameState | wind <- newWind }

countdownStep : Time -> GameState -> GameState
countdownStep chrono gameState = { gameState | countdown <- Just (gameState.startDuration - chrono) }

stepGame : Input -> GameState -> GameState
stepGame input gameState =
  mouseStep input.mouseInput 
    <| moveStep input.clock input.windowInput 
    <| keysStep input.keyboardInput input.otherKeyboardInput
    <| windStep input.clock 
    <| countdownStep input.chrono gameState
