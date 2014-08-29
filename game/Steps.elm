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
  let player = gameState.player
      center = case drag of
        Just (x',y') -> let (x,y) = mouse in sub (floatify (x - x', y' - y)) player.center
        Nothing      -> player.center
  in
    { gameState | player <- { player | center <- center } }

tackTargetReached : Player -> Maybe Float -> Bool
tackTargetReached player targetMaybe =
  case (targetMaybe, player.controlMode) of
    (Just target, FixedWindAngle) -> abs (target - player.windAngle) < 0.1
    (Just target, FixedDirection) -> abs (target - player.direction) < 0.1
    (Nothing, _)                  -> False

getTackTarget : Player -> Bool -> Maybe Float
getTackTarget player spaceKey =
  case (player.tackTarget, spaceKey) of
    -- target en cours
    (Just _, _) ->
      -- si direction cible atteinte, on arrête le virement
      if tackTargetReached player player.tackTarget then Nothing else player.tackTarget
    -- si touche espace pressée, on défini la cible
    (Nothing, True) ->
      case player.controlMode of
        FixedWindAngle -> Just -player.windAngle
        FixedDirection -> Just (ensure360 (player.windOrigin - player.windAngle))
    -- sinon, pas de cible
    (Nothing, False) -> Nothing



getTurn : Maybe Float -> Player -> UserArrows -> Bool -> Float
getTurn tackTarget player arrows fineTurn =
  case (tackTarget, player.controlMode, arrows.x, arrows.y) of
    -- virement en cours
    (Just target, _, _, _) ->
      case player.controlMode of
        FixedDirection ->
          let maxTurn = minimum [2, (abs (player.direction - target))]
          in
            if ensure360 (player.direction - target) > 180 then maxTurn else -maxTurn
        FixedWindAngle ->
          let maxTurn = minimum [2, (abs (player.windAngle - target))]
          in
            if target > 90 || (target < 0 && target >= -90) then -maxTurn else maxTurn
    -- pas de virement ni de touche flèche, donc contrôle auto
    (Nothing, FixedDirection, 0, 0) -> 0
    (Nothing, FixedWindAngle, 0, 0) -> (player.windOrigin + player.windAngle) - player.direction
    -- changement de direction via touche flèche
    (Nothing, _, x, y) -> if fineTurn then x else x * 3

keysForPlayerStep : KeyboardInput -> Player -> Player
keysForPlayerStep ({arrows, lockAngle, tack, fineTurn}) player =
  let forceTurn = arrows.x /= 0
      tackTarget = if forceTurn then Nothing else getTackTarget player tack
      turn = getTurn tackTarget player arrows fineTurn
      direction = ensure360 <| player.direction + turn
      windAngle = angleToWind direction player.windOrigin
      turnedPlayer = { player | direction <- direction,
                            windAngle <- windAngle }
      tackTargetAfterTurn = if tackTargetReached turnedPlayer tackTarget then Nothing else tackTarget
      controlMode = if | forceTurn -> FixedDirection
                       | arrows.y > 0 || lockAngle -> FixedWindAngle
                       | otherwise -> turnedPlayer.controlMode
  in
    { turnedPlayer | controlMode <- controlMode,
                   tackTarget <- tackTargetAfterTurn }

keysStep : KeyboardInput -> GameState -> GameState
keysStep keyboardInput gameState =
  let playerUpdated = keysForPlayerStep keyboardInput gameState.player
  in  { gameState | player <- playerUpdated }

gatePassedInX : Gate -> (Point,Point) -> Bool
gatePassedInX gate ((x,y),(x',y')) =
  let a = (y - y') / (x - x')
      b = y - a * x
      xGate = (gate.y - b) / a
  in
    (abs xGate) <= gate.width / 2

gatePassedFromNorth : Gate -> (Point,Point) -> Bool
gatePassedFromNorth gate (p,p') =
  (snd p) > gate.y && (snd p') <= gate.y && (gatePassedInX gate (p,p'))

gatePassedFromSouth : Gate -> (Point,Point) -> Bool
gatePassedFromSouth gate (p,p') =
  (snd p) < gate.y && (snd p') >= gate.y && (gatePassedInX gate (p,p'))

getPassedGates : Player -> Time -> Course -> (Point,Point) -> [Time]
getPassedGates player now ({upwind, downwind, laps}) step =
  case findNextGate player laps of
    -- ligne de départ
    Just StartLine -> if | gatePassedFromSouth downwind step -> now :: player.passedGates
                         | otherwise                         -> player.passedGates
    -- bouée au vent
    Just Upwind    -> if | gatePassedFromSouth upwind step   -> now :: player.passedGates
                         | gatePassedFromSouth downwind step -> tail player.passedGates
                         | otherwise                         -> player.passedGates
    -- bouée sous le vent
    Just Downwind  -> if | gatePassedFromNorth downwind step -> now :: player.passedGates
                         | gatePassedFromNorth upwind step   -> tail player.passedGates
                         | otherwise                         -> player.passedGates
    -- arrivée déjà franchie
    Nothing        -> player.passedGates

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
      outOfBounds = not (inBox p gameState.course.bounds)
      onIsland = any (\i -> distance i.location p <= i.radius) gameState.course.islands
  in
    outOfBounds || stuckOnMark || onIsland

getCenterAfterMove : Point -> Point -> Point -> (Float,Float) -> (Point)
getCenterAfterMove (x,y) (x',y') (cx,cy) (w,h) =
  let refocus n n' c d margin =
        let min = c - (d / 2)
            mmin = min + margin
            max = c + (d / 2)
            mmax = max - margin
        in
          if | n < min || n > max -> c
             | n < mmin           -> if n' < n then c - (n - n') else c
             | n > mmax           -> if n' > n then c + (n' - n) else c
             | n' < mmin          -> c - (n - n')
             | n' > mmax          -> c + (n' - n)
             | otherwise          -> c
  in
    (refocus x x' cx w (w * 0.2), refocus y y' cy h (h * 0.4))

movePlayer : Time -> Float -> GameState -> (Int,Int) -> Player -> Player
movePlayer now delta gameState dimensions player =
  let {position, direction, velocity, windAngle, passedGates} = player
      newVelocity = playerVelocity player.windAngle velocity
      nextPosition = movePoint position delta newVelocity direction
      stuck = isStuck nextPosition gameState
      newPosition = if stuck then position else nextPosition
      newPassedGates = if gameState.countdown <= 0
        then getPassedGates player now gameState.course (position, newPosition)
        else player.passedGates
      newCenter = getCenterAfterMove position newPosition player.center (floatify dimensions)
      newWake = take 40 (newPosition :: player.wake)
  in  { player | position <- newPosition,
                 velocity <- if stuck then 0 else newVelocity,
                 center <- newCenter,
                 wake <- newWake,
                 passedGates <- newPassedGates }

moveStep : Time -> Float -> (Int,Int) -> GameState -> GameState
moveStep now delta dims gameState =
  let playerMoved = movePlayer now delta gameState dims gameState.player
  in  { gameState | player <- playerMoved }

-- will be useful when gusts will be implemented
updateWindForPlayer : Wind -> Player -> Player
updateWindForPlayer wind player =
  { player | windOrigin <- wind.origin }

windStep : Float -> Time -> [Gust] -> GameState -> GameState
windStep delta now gusts ({wind, player} as gameState) =
  let o1 = cos (inSeconds now / 8) * 10
      o2 = cos (inSeconds now / 5) * 5
      newOrigin = o1 + o2 |> ensure360
      newWind = { wind | origin <- newOrigin,
                         gusts <- gusts }
      playerWithWind = updateWindForPlayer wind player
  in { gameState | wind <- newWind,
                   player <- playerWithWind }

raceInputStep : RaceInput -> GameState -> GameState
raceInputStep {now,startTime,course,opponents,buoys,playerSpell,triggeredSpells,leaderboard} gameState =
  { gameState | opponents <- opponents,
                buoys <- buoys,
                playerSpell <- playerSpell,
                triggeredSpells <- triggeredSpells,
                course <- maybe gameState.course id course,
                leaderboard <- leaderboard,
                countdown <- startTime - now }

stepGame : Input -> GameState -> GameState
stepGame input gameState =
  mouseStep input.mouseInput
    <| moveStep input.raceInput.now input.delta input.windowInput
    <| keysStep input.keyboardInput
    <| windStep input.delta input.raceInput.now input.raceInput.gusts
    <| raceInputStep input.raceInput gameState
