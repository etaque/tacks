module Steps where

import Inputs (..)
import Game (..)
import Geo (..)
import Core (..)

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
          in  if ensure360 (player.direction - target) > 180 then maxTurn else -maxTurn
        FixedWindAngle ->
          let maxTurn = minimum [2, (abs (player.windAngle - target))]
          in  if target > 90 || (target < 0 && target >= -90) then -maxTurn else maxTurn
    -- pas de virement ni de touche flèche, donc contrôle auto
    (Nothing, FixedDirection, 0, 0) -> 0
    (Nothing, FixedWindAngle, 0, 0) -> ensure360 ((player.windOrigin + player.windAngle) - player.direction)
    -- changement de direction via touche flèche
    (Nothing, _, x, y) -> if fineTurn then x else x * 3

keysForPlayerStep : KeyboardInput -> [Spell] -> Player -> Player
keysForPlayerStep ({arrows, lockAngle, tack, fineTurn, spellCast, startCountdown}) spells player =
  let forceTurn = arrows.x /= 0
      tackTarget = if forceTurn then Nothing else getTackTarget player tack
      turn = getTurn tackTarget player arrows fineTurn
      direction = ensure360 <| player.direction + (if(containsSpell "PoleInversion" spells) then -turn else turn)
      windAngle = angleToWind direction player.windOrigin
      turnedPlayer = { player | direction <- direction,
                            windAngle <- windAngle }
      tackTargetAfterTurn = if tackTargetReached turnedPlayer tackTarget then Nothing else tackTarget
      controlMode = if | forceTurn -> FixedDirection
                       | arrows.y > 0 || lockAngle -> FixedWindAngle
                       | otherwise -> turnedPlayer.controlMode
  in  { turnedPlayer | controlMode <- controlMode,
                       tackTarget <- tackTargetAfterTurn,
                       spellCast <- spellCast,
                       startCountdown <- startCountdown }

keysStep : KeyboardInput -> GameState -> GameState
keysStep keyboardInput gameState =
  let playerUpdated = keysForPlayerStep keyboardInput gameState.triggeredSpells gameState.player
  in  { gameState | player <- playerUpdated }

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
  let {position, direction, velocity, windAngle, crossedGates} = player
      newVelocity = playerVelocity player.windSpeed player.windAngle velocity
      nextPosition = movePoint position delta newVelocity direction
      stuck = isStuck nextPosition gameState
      newPosition = if stuck then position else nextPosition
      newCenter = getCenterAfterMove position newPosition player.center (floatify dimensions)
      newWake = take 40 (newPosition :: player.wake)
  in  { player | position <- newPosition,
                 velocity <- if stuck then 0 else newVelocity,
                 center <- newCenter,
                 wake <- newWake }

moveStep : Time -> Float -> (Int,Int) -> GameState -> GameState
moveStep now delta dims gameState =
  let playerMoved = movePlayer now delta gameState dims gameState.player
  in  { gameState | player <- playerMoved }

updatePlayerWind : Wind -> Player -> Player
updatePlayerWind wind player =
  let gustsOnPlayer = filter (\g -> distance player.position g.position < g.radius) wind.gusts
      (windOrigin, windSpeed) = if isEmpty gustsOnPlayer
        then (wind.origin, wind.speed)
        else let gust = head gustsOnPlayer
             in  (ensure360 gust.angle, wind.speed + gust.speed)
  in  { player | windOrigin <- windOrigin,
                 windSpeed <- windSpeed }

updateVmg : Player -> Player
updateVmg player =
  let u = getUpwindVmg player.windSpeed
      d = getDownwindVmg player.windSpeed
  in  { player | upwindVmg <- u,
                 downwindVmg <- d }

windStep : Wind -> GameState -> GameState
windStep wind gameState =
  let player = updatePlayerWind wind gameState.player |> updateVmg
  in  { gameState | wind <- wind,
                    player <- player }

raceInputStep : RaceInput -> GameState -> GameState
raceInputStep {now,startTime,course,crossedGates,nextGate,opponents,buoys,playerSpell,triggeredSpells,leaderboard} ({player} as gameState) =
  let nextGateType = case nextGate of
        Just "StartLine"    -> Just StartLine
        Just "DownwindGate" -> Just Downwind
        Just "UpwindGate"   -> Just Upwind
        _                   -> Nothing
      updatedPlayer = { player | nextGate <- nextGateType,
                                 crossedGates <- crossedGates }
  in  { gameState | opponents <- opponents,
                    player <- updatedPlayer,
                    course <- maybe gameState.course id course,
                    buoys <- buoys,
                    playerSpell <- playerSpell,
                    triggeredSpells <- triggeredSpells,
                    leaderboard <- leaderboard,
                    countdown <- mapMaybe (\st -> st - now) startTime }

stepGame : Input -> GameState -> GameState
stepGame input gameState =
  mouseStep input.mouseInput
    <| moveStep input.raceInput.now input.delta input.windowInput
    <| keysStep input.keyboardInput
    <| windStep input.raceInput.wind
    <| raceInputStep input.raceInput gameState
