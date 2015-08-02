module Render.Dashboard where

import Render.Utils exposing (..)
import Core exposing (..)
import Game exposing (..)
import Layout exposing (..)

import String
import List exposing (..)
import Maybe as M
import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Color exposing (white)
import Time exposing (Time)

s : Element
s = spacer 20 20

xs : Element
xs = spacer 5 5

type alias BoardLine =
  { id:       String
  , handle:   Maybe String
  , position: Maybe Int
  , delta:    Maybe Time
  }

buildBoardLine : BoardLine -> Element
buildBoardLine {id,handle,position,delta} =
  let
    positionText = M.map (\p -> toString p ++ ".") position |> M.withDefault "  "
    handleText   = M.withDefault "Anonymous" handle |> fixedLength 12
    deltaText    = M.map (\d -> "+" ++ toString (d / 1000)) delta |> M.withDefault "-"
  in
    String.join " " [positionText, handleText, deltaText]
      |> baseText
      |> leftAligned

getPlayerEntry : Player -> Element
getPlayerEntry player =
  let
    line =
      { id       = player.id
      , handle   = player.handle
      , position = Nothing
      , delta    = Nothing
      }
  in
    buildBoardLine line

getPlayerEntries : GameState -> Element
getPlayerEntries {opponents,playerState} =
  let
    players = playerState.player :: (map .player opponents)
  in
    map getPlayerEntry players |> flow down


getLeaderboardLine : PlayerTally -> Int -> PlayerTally -> Element
getLeaderboardLine leaderTally position tally =
  let
    delta = if length tally.gates == length leaderTally.gates
      then
        case (head tally.gates, head leaderTally.gates) of
          (Just g1, Just g2) ->
            Just (g1 - g2)
          _ ->
            Nothing
      else
        Nothing
    line =
      { id       = tally.playerId
      , handle   = tally.playerHandle
      , position = Just (position + 1)
      , delta    = delta
      }
  in
    buildBoardLine line

getLeaderboard : GameState -> Element
getLeaderboard {leaderboard,playerState} =
  let
    showLeader leader =
      indexedMap (getLeaderboardLine leader) leaderboard |> flow down
  in
    M.map showLeader (head leaderboard) |> M.withDefault empty

getBoard : GameState -> Element
getBoard gameState =
  if | isEmpty gameState.leaderboard -> getPlayerEntries gameState
     | otherwise -> getLeaderboard gameState

getHelp : GameState -> Element
getHelp gameState =
  helpMessage |> baseText |> leftAligned |> opacity 0.8


-- Main status (big font size)

getMainStatus : GameState -> Element
getMainStatus ({playerState} as gameState) =
  let
    op = if isStarted gameState then 0.5 else 1
    s = getTimer gameState
  in
    bigText s |> centered |> opacity op


getTimer : GameState -> String
getTimer {startTime, now, playerState} =
  case startTime of
    Just t ->
      let
        timer =
          if isNothing playerState.nextGate then
            M.withDefault 0 (head playerState.crossedGates)
          else
            t - now
      in
        formatTimer timer (isNothing playerState.nextGate)
    Nothing -> "start pending"


-- Sub status (normal font size)

getSubStatus : GameState -> Element
getSubStatus ({startTime,now,playerState,course} as gameState) =
  let
    s = case startTime of
      Just t ->
        if t > now
          then "be ready"
          else getFinishingStatus gameState
      Nothing ->
        startCountdownMessage
  in
    baseText s |> centered


getFinishingStatus : GameState -> String
getFinishingStatus ({course,playerState} as gameState) =
  case playerState.nextGate of
    Nothing ->
      "finished"
    Just StartLine ->
      "go!"
    _ ->
      getGatesCount course playerState

getGatesCount : Course -> PlayerState -> String
getGatesCount course player =
  "gate " ++ toString (length player.crossedGates) ++ "/" ++ (toString (1 + course.laps * 2))

getTimeTrialFinishingStatus : GameState -> PlayerState -> String
getTimeTrialFinishingStatus {playerState,ghosts} {player,crossedGates} =
  case findPlayerGhost playerState.player.id ghosts of
    Just playerGhost ->
      let
        previousTimeMaybe = head playerGhost.gates
        newTimeMaybe = head crossedGates
      in
        case (previousTimeMaybe, newTimeMaybe) of
          (Just previousTime, Just newTime) ->
            if newTime < previousTime
              then toString (newTime - previousTime) ++ "ms\nnew best time!"
              else "+" ++ toString (newTime - previousTime) ++ "ms\ntry again?"
          _ ->
            ""
    Nothing ->
      case player.handle of
        Just _ -> "you did it!"
        Nothing -> "please create an account to save your run"

--

getWindWheel : Wind -> Element
getWindWheel wind =
  let
    r = 30
    c = circle r |> outlined (solid white)
    windOriginRadians = toRadians wind.origin
    windMarker = polygon [(0,4),(-4,-4),(4,-4)]
      |> filled white
      |> rotate (windOriginRadians + pi/2)
      |> move (fromPolar (r + 4, windOriginRadians))
    windOriginText = ((toString (round wind.origin)) ++ "&deg;")
      |> baseText |> centered |> toForm
      |> move (0, r + 25)
    windSpeedText = ((toString (round wind.speed)) ++ "kn")
      |> baseText |> centered |> toForm
    legend = "WIND" |> baseText |> centered |> toForm |> move (0, -50)
  in
    collage 80 120 [c, windMarker, windOriginText, windSpeedText, legend]

getVmgBar : PlayerState -> Element
getVmgBar {windAngle,velocity,vmgValue,downwindVmg,upwindVmg} =
  let barHeight = 120
      barWidth = 8
      contour = rect (barWidth + 6) (barHeight + 6)
        |> outlined { defaultLine | width <- 2, color <- white, cap <- Round, join <- Smooth }
        |> alpha 0.5
      theoricVmgValue = if (abs windAngle) < 90 then upwindVmg.value else downwindVmg.value
      boundedVmgValue = if | vmgValue > theoricVmgValue -> theoricVmgValue
                           | vmgValue < 0               -> 0
                           | otherwise                  -> vmgValue
      height = barHeight * boundedVmgValue / theoricVmgValue
      level = rect barWidth height
        |> filled white
        |> move (0, (height - barHeight) / 2)
        |> alpha 0.8
      bar = group [level, contour]
        |> move (0, 10)
      legend = "VMG" |> baseText |> centered |> toForm |> move (0, -(barHeight / 2) - 10)
  in
      collage 80 (barHeight + 40) [bar, legend]


topLeftElements : GameState -> List Element
topLeftElements gameState =
  [ getBoard gameState
  , getHelp gameState
  ]

topCenterElements : GameState -> List Element
topCenterElements gameState =
  [ getMainStatus gameState
  , getSubStatus gameState
  ]

topRightElements : GameState -> List Element
topRightElements {wind,playerState} =
  [ getWindWheel wind
  , getVmgBar playerState
  ]

buildDashboard : GameState -> (Int,Int) -> DashboardLayout
buildDashboard gameState (w,h) =
    { topLeft = topLeftElements gameState
    , topRight = topRightElements gameState
    , topCenter = topCenterElements gameState
    , bottomCenter = []
    }
