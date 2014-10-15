module Render.Dashboard where

import Render.Utils (..)
import Core (..)
import Geo (..)
import Game (..)
import String
import Text
import Maybe (maybe)

s = spacer 20 20


getGatesCount : Course -> PlayerState -> Element
getGatesCount course player =
  let count = minimum [((length player.crossedGates) + 1) // 2, course.laps]
  in  "Gate " ++ show (length player.crossedGates) ++ "/" ++ (show (1 + course.laps * 2))
        |> baseText
        |> leftAligned

getLeaderboardLine : PlayerTally -> Int -> PlayerTally -> String
getLeaderboardLine leaderTally position tally =
  let delta = if length tally.gates == length leaderTally.gates
        then "+" ++ show ((head tally.gates - head leaderTally.gates) / 1000) ++ "\""
        else "-"
      handle = maybe "Anonymous" identity tally.playerHandle
  in  show (position + 1) ++ ". " ++ (fixedLength 12 handle) ++ " " ++ delta

getLeaderboard : [PlayerTally] -> Element
getLeaderboard leaderboard =
  if isEmpty leaderboard then
    empty
  else
    let leader = head leaderboard
    in  indexedMap (getLeaderboardLine leader) leaderboard
          |> join "\n"
          |> baseText |> leftAligned

getHelp : Maybe Float -> Element
getHelp countdownMaybe =
  if maybe True (\c -> c > 0) countdownMaybe then
    helpMessage |> baseText |> centered
  else
    empty

getCountdown : GameState -> Element
getCountdown {countdown,isMaster,playerState} =
  let msg s = baseText s |> centered
  in  case countdown of
        Just c ->
          if c > 0
            then msg <| formatCountdown c
            else case playerState.nextGate of
              Just "StartLine" -> msg "Go!"
              Nothing          -> msg "Finished"
              _                -> empty
        Nothing ->
          if isMaster
            then msg startCountdownMessage
            else empty

getWindWheel : Wind -> PlayerState -> Element
getWindWheel wind player =
  let r = 30
      c = circle r |> outlined (solid white)
      windOriginRadians = toRadians wind.origin
      windMarker = polygon [(0,4),(-4,-4),(4,-4)]
        |> filled white
        |> rotate (windOriginRadians + pi/2)
        |> move (fromPolar (r + 4, windOriginRadians))
      windOriginText = ((show (round wind.origin)) ++ "&deg;")
        |> baseText |> centered |> toForm
        |> move (0, r + 25)
      windSpeedText = ((show (round wind.speed)) ++ "kn")
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


topLeftElements : GameState -> [Element]
topLeftElements {leaderboard,course,playerState} =
  [ getGatesCount course playerState
  , s
  , getLeaderboard leaderboard
  ]

midTopElements : GameState -> [Element]
midTopElements gameState =
  [getCountdown gameState]

topRightElements : GameState -> [Element]
topRightElements {wind,playerState} =
  [ getWindWheel wind playerState
  , s
  , getVmgBar playerState
  ]

midBottomElements : GameState -> [Element]
midBottomElements {countdown} =
  [getHelp countdown]


renderDashboard : GameState -> (Int,Int) -> Element
renderDashboard gameState (w,h) =
  layers
    [ container w h (topLeftAt (Absolute 20) (Absolute 20)) <| flow down (topLeftElements gameState)
    , container w h (midTopAt (Relative 0.5) (Absolute 20)) <| flow down (midTopElements gameState)
    , container w h (topRightAt (Absolute 20) (Absolute 20)) <| flow down (topRightElements gameState)
    , container w h (midBottomAt (Relative 0.5) (Absolute 20)) <| flow up (midBottomElements gameState)
    ]
