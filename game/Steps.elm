module Steps where

import Inputs (..)
import Game (..)
import Geo (..)
import Core (..)

import Steps.GateCrossing (gateCrossingStep)
import Steps.Moving (movingStep)
import Steps.Turning (turningStep)
import Steps.Vmg (vmgStep)
import Steps.Wind (windStep)

import Maybe as M
import List as L
import Debug

centerStep : GameState -> GameState
centerStep gameState =
  let newCenter = gameState.playerState.position
  in  { gameState | center <- newCenter }

--

updateWindStep : Float -> GameState -> GameState
updateWindStep elapsed ({course} as gameState) =
  case gameState.gameMode of
    TimeTrial ->
      let
        clock = serverClock gameState
        origin = windOrigin course.windGenerator clock
        speed = windSpeed course.windGenerator clock
        wind = spawnGust gameState
        gusts = L.map (updateGust course wind elapsed clock) wind.gusts
          |> L.filter (\g -> (snd g.position) + g.radius > areaBottom course.area)
        newWind = { wind
          | origin <- origin
          , speed <- speed
          , gusts <- gusts
          }
      in
        { gameState | wind <- newWind }
    _ ->
      gameState



spawnGust : GameState -> Wind
spawnGust ({course,wind,creationTime} as gameState) =
  let
    clock = serverClock gameState
    nextGustTime = toFloat <| wind.gustCounter * course.gustGenerator.interval * 1000
  in
    if clock >= nextGustTime || wind.gustCounter == 0 then
      case nthGustDef wind.gustCounter course.gustGenerator of
        Just gustDef ->
          let
            gustSeconds = nextGustTime / 1000 |> floor |> toFloat
            creationTimeSeconds = creationTime / 1000 |> floor |> toFloat
            seed = gustSeconds * creationTimeSeconds + creationTimeSeconds

            position = (genX seed 100 course.area, areaTop course.area)

            gust =
              { position = position
              , angle = gustDef.angle
              , speed = gustDef.speed
              , radius = 0
              , maxRadius = gustDef.radius
              , spawnedAt = nextGustTime
              }

            newGusts = gust :: wind.gusts
            newWind = { wind
              | gusts <- newGusts
              , gustCounter <- wind.gustCounter + 1
              }
          in
            newWind

        Nothing ->
          wind
    else
      wind

nthGustDef : Int -> GustGenerator -> Maybe GustDef
nthGustDef n {defs} =
  if L.isEmpty defs then Nothing else lift (n % (L.length defs)) defs


updateGust : Course -> Wind -> Float -> Float -> Gust -> Gust
updateGust course wind elapsed clock gust =
  let
    groundSpeed = wind.speed + gust.speed
    groundDirection = ensure360 (gust.angle + 180)

    newPosition = movePoint gust.position elapsed groundSpeed groundDirection

    maxRadiusAfterSeconds = 20
    radius = L.minimum [ (clock - gust.spawnedAt) * 0.001 * gust.maxRadius / maxRadiusAfterSeconds, gust.maxRadius ]
  in
    { gust | position <- newPosition, radius <- radius }

windOrigin : WindGenerator -> Float -> Float
windOrigin {wavelength1,amplitude1,wavelength2,amplitude2} clock =
  cos (clock * 0.0005 / wavelength1) * amplitude1 + cos (clock * 0.0005 / wavelength2) * amplitude2

baseWindSpeed : Float
baseWindSpeed = 17

windSpeed : WindGenerator -> Float -> Float
windSpeed {wavelength1,amplitude1,wavelength2,amplitude2} clock =
  baseWindSpeed + (cos (clock * 0.0005 / wavelength1) * 4 - cos (clock * 0.0005 / wavelength2) * 5) * 0.5

--

moveOpponentState : OpponentState -> Float -> OpponentState
moveOpponentState state delta =
  let
    position = movePoint state.position delta state.velocity state.heading
  in
    { state | position <- position }


updateOpponent : Maybe Opponent -> Float -> Opponent -> Opponent
updateOpponent previousMaybe delta opponent =
  case previousMaybe of
    Just previous ->
      if previous.state.time == opponent.state.time then
        { opponent | state <- moveOpponentState opponent.state delta }
      else
        opponent
    Nothing ->
      opponent

updateOpponents : List Opponent -> Float -> List Opponent -> List Opponent
updateOpponents previousOpponents delta newOpponents =
  let
    findPrevious o = find (\po -> po.player.id == o.player.id) previousOpponents
  in
    L.map (\o -> updateOpponent (findPrevious o) delta o) newOpponents

raceInputStep : RaceInput -> Clock -> GameState -> GameState
raceInputStep raceInput {delta,time} ({playerState} as gameState) =
  let
    { serverNow, startTime, opponents, ghosts, leaderboard, isMaster, initial, clientTime } = raceInput

    stalled = serverNow == gameState.serverNow

    roundTripDelay = if stalled then
      gameState.roundTripDelay
    else
      time - clientTime

    now = if gameState.live then
      gameState.now + delta
    else
      serverNow

    updatedOpponents = updateOpponents gameState.opponents delta opponents

    newPlayerState = { playerState | time <- now }

    wind = case gameState.gameMode of
      TimeTrial ->
        gameState.wind
      _ ->
        raceInput.wind

  in
    { gameState
      | opponents <- updatedOpponents
      , ghosts <- ghosts
      , wind <- wind
      , leaderboard <- leaderboard
      , serverNow <- serverNow
      , now <- now
      , playerState <- newPlayerState
      , startTime <- startTime
      , isMaster <- isMaster
      , live <- not initial
      , localTime <- time
      , roundTripDelay <- roundTripDelay
    }

playerTimeStep : Float -> PlayerState -> PlayerState
playerTimeStep elapsed state =
  { state | time <- state.time + elapsed }

runEscapeStep : Bool -> PlayerState -> PlayerState
runEscapeStep doEscape playerState =
  let
    crossedGates = if doEscape then [] else playerState.crossedGates
  in
    { playerState | crossedGates <- crossedGates }
    

playerStep : KeyboardInput -> Float -> GameState -> GameState
playerStep keyboardInput elapsed gameState =
  let
    playerState =
      turningStep elapsed keyboardInput gameState.playerState
        |> windStep gameState
        |> vmgStep
        |> movingStep elapsed gameState.course
        |> gateCrossingStep gameState.playerState gameState
        |> playerTimeStep elapsed
        |> runEscapeStep keyboardInput.escapeRun
  in
    { gameState | playerState <- playerState }


stepGame : GameInput -> GameState -> GameState
stepGame {raceInput, clock, windowInput, keyboardInput} gameState =
  raceInputStep raceInput clock gameState
    |> updateWindStep clock.delta
    |> playerStep keyboardInput clock.delta
    |> centerStep
