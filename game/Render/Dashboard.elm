module Render.Dashboard where

import Render.Utils (..)
import Core (..)
import Geo (..)
import Game (..)
import String
import Text
import Maybe

s = spacer 20 20

getGatesCount : Course -> Player -> Element
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
  in  show (position + 1) ++ ". " ++ (fixedLength 12 tally.player.name) ++ " " ++ delta

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
  if Maybe.maybe True (\c -> c > 0) countdownMaybe then
    helpMessage |> baseText |> centered
  else
    empty

getCountdown : GameState -> Element
getCountdown {countdown,isMaster,player} =
  let msg s = baseText s |> centered
  in  case countdown of
        Just c ->
          if c > 0
            then msg <| formatCountdown c
            else if player.nextGate == Just "StartLine"
              then msg "Go!"
              else empty
        Nothing ->
          if isMaster
            then msg startCountdownMessage
            else empty

topLeftElements : GameState -> [Element]
topLeftElements {leaderboard,course,player} =
  [getGatesCount course player, s, getLeaderboard leaderboard]

midTopElements : GameState -> [Element]
midTopElements gameState =
  [getCountdown gameState]

topRightElements : GameState -> [Element]
topRightElements gameState =
  [empty]

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
