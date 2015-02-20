module Render.Dashboard where

import Render.Utils (..)
import Core (..)
import Geo (..)
import Game (..)
import Layout (..)

import String
import Text (leftAligned,centered)
import List (..)
import Maybe as M
import Graphics.Input (customButton)
import Graphics.Element (..)
import Graphics.Collage (..)
import Color (white)
import Time (Time)
import Signal

s = spacer 20 20
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
      then Just (head tally.gates - head leaderTally.gates)
      else Nothing
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
  if isEmpty leaderboard then
    empty
  else
    let
      leader = head leaderboard
    in
      indexedMap (getLeaderboardLine leader) leaderboard
        |> flow down

getBoard : GameState -> Element
getBoard gameState =
  if | gameState.gameMode == TimeTrial -> empty
     | isEmpty gameState.leaderboard -> getPlayerEntries gameState
     | otherwise -> getLeaderboard gameState

getHelp : GameState -> Element
getHelp gameState =
  case gameState.gameMode of
    Race -> empty
    TimeTrial -> helpMessage |> baseText |> leftAligned |> opacity 0.8


-- Main status (big font size)

getMainStatus : GameState -> Element
getMainStatus ({countdown, gameMode, playerState} as gameState) =
  let
    op = if isInProgress gameState then 0.5 else 1
    s = getTimer gameState
  in
    bigText s |> centered |> opacity op

getFinishTime : List Float -> Float
getFinishTime gates =
  let
    finish = head gates
    start = head (reverse gates)
  in
    finish - start


getTimer : GameState -> String
getTimer {countdown, playerState} =
  case countdown of
    Just c ->
      let
        t = if isNothing playerState.nextGate then getFinishTime playerState.crossedGates else c
      in
        formatTimer t (isNothing playerState.nextGate)
    Nothing -> "start pending"


-- Sub status (normal font size)

getSubStatus : GameState -> Element
getSubStatus ({countdown,isMaster,playerState,course,gameMode} as gameState) =
  let
    op = 1
    s = case countdown of
      Just c ->
        if c > 0
          then "be ready"
          else getFinishingStatus gameState
      Nothing ->
        if isMaster
          then startCountdownMessage
          else "" -- start pending
  in
    baseText s |> centered |> opacity op


getFinishingStatus : GameState -> String
getFinishingStatus ({course,gameMode,playerState} as gameState) =
  case playerState.nextGate of
    Nothing -> case gameMode of
      Race      -> "finished"
      TimeTrial -> getTimeTrialFinishingStatus gameState playerState
    Just "StartLine" -> "go!"
    _                -> getGatesCount course playerState

getGatesCount : Course -> PlayerState -> String
getGatesCount course player =
  "gate " ++ toString (length player.crossedGates) ++ "/" ++ (toString (1 + course.laps * 2))

getTimeTrialFinishingStatus : GameState -> PlayerState -> String
getTimeTrialFinishingStatus {playerState,ghosts} {player,crossedGates} =
  case findPlayerGhost playerState.player.id ghosts of
    Just playerGhost ->
      let
        previousTime = head playerGhost.gates
        newTime = head crossedGates
      in
        if newTime < previousTime
          then toString (newTime - previousTime) ++ "ms\nnew best time!"
          else "+" ++ toString (newTime - previousTime) ++ "ms\ntry again?"
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
