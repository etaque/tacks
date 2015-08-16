module Game.Render.Dashboard where

import Game.Render.Utils exposing (..)
import Game.Core exposing (..)
import Game.Models exposing (..)
import Game.Layout exposing (..)
import Models exposing (..)

import String
import List exposing (..)
import Maybe as M
import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Color exposing (white)
import Time exposing (Time)


buildDashboard : GameState -> (Int,Int) -> DashboardLayout
buildDashboard gameState (w,h) =
    { topLeft = topLeftElements gameState
    , topRight = topRightElements gameState
    , topCenter = topCenterElements gameState
    , bottomCenter = []
    }

topLeftElements : GameState -> List Element
topLeftElements {wind, windHistory, playerState} =
  [ getVmgBar playerState
  ]

topCenterElements : GameState -> List Element
topCenterElements gameState =
  [ getMainStatus gameState
  , getSubStatus gameState
  ]

topRightElements : GameState -> List Element
topRightElements {wind, windHistory, playerState} =
  [ getWindWheel wind
  , getWindSpeedGraph wind windHistory
  ]


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


getWindSpeedGraph : Wind -> WindHistory -> Element
getWindSpeedGraph wind windHistory =
  let
    stepWidth = 4
    windCoef = 4
    windSpeeds = (windHistory.speeds)

    samplingInterpol = (toFloat windHistory.sampleCounter) * stepWidth / (toFloat windHistorySampling)
    historyPath = windSpeeds
      |> indexedMap (,)
      |> map (\(t, s) -> (toFloat t * -stepWidth, s * windCoef))
      |> path
      |> traced (solid white)
      |> move ( stepWidth * (toFloat windHistoryLength) - samplingInterpol, 0)

    currentPoint = circle 2
      |> filled white
      |> move ((toFloat windHistoryLength) * stepWidth, wind.speed * windCoef)

    graph = group [ historyPath, currentPoint ]
      |> move (-100, 0)
  in
    collage 250 200 [ graph ]


s : Element
s = spacer 20 20

xs : Element
xs = spacer 5 5
