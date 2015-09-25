module Game.Render.Dashboard.Status where

import Game.Models exposing (..)
import Game.Core exposing (..)
import Models exposing (..)

import Game.Render.SvgUtils exposing (..)

import String
import List exposing (..)
import Maybe as M
import Time exposing (Time)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)


render : GameState -> Svg
render gameState =
  g []
    [ renderTimer gameState
    , renderSubStatus gameState
    ]


renderTimer : GameState -> Svg
renderTimer gameState =
  text'
    [ textAnchor "middle"
    , fontSize "42px"
    , opacity (toString <| timerOpacity gameState)
    ]
    [ text (getTimer gameState) ]


timerOpacity : GameState -> Float
timerOpacity gameState =
  if isStarted gameState then
    0.2
  else
    let
      ms = floor (raceTime gameState) % 1000
    in
      if ms < 500 then 0.5 else (1000 - toFloat ms) / 500 * 0.5


getTimer : GameState -> String
getTimer {timers, playerState} =
  case timers.startTime of
    Just t ->
      let
        timer =
          if isNothing playerState.nextGate then
            M.withDefault 0 (head playerState.crossedGates)
          else
            t - timers.now
      in
        formatTimer timer (isNothing playerState.nextGate)
    Nothing -> "START PENDING"


formatTimer : Time -> Bool -> String
formatTimer t showMs =
  let
    t' = t |> ceiling |> abs
    totalSeconds = t' // 1000
    minutes = totalSeconds // 60
    seconds = if showMs || t <= 0 then totalSeconds `rem` 60 else (totalSeconds `rem` 60) + 1
    millis = t' `rem` 1000
    sMinutes = toString minutes
    sSeconds = String.padLeft 2 '0' (toString seconds)
    sMillis = if showMs then "." ++ (String.padLeft 3 '0' (toString millis)) else ""
  in
    sMinutes ++ ":" ++ sSeconds ++ sMillis


renderSubStatus : GameState -> Svg
renderSubStatus gameState =
  text'
    [ textAnchor "middle"
    , fontSize "18px"
    , opacity "0.5"
    , y "24"
    ]
    [ text (getSubStatus gameState) ]

getSubStatus : GameState -> String
getSubStatus gameState =
  if isStarted gameState then
    let
      counter = List.length gameState.playerState.crossedGates
      total = gameState.course.laps * 2 + 1
    in
      if counter == total then
        "FINISHED"
      else
        "gate " ++ toString counter ++ " on " ++ toString total
  else
    case gameState.timers.startTime of
      Just _ ->
        ""
      Nothing ->
        "press C to start countdown"

