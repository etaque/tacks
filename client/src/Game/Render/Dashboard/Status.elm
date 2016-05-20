module Game.Render.Dashboard.Status exposing (..)

import Game.Models exposing (..)
import Game.Core exposing (..)
import String
import List exposing (..)
import Time exposing (Time)
import Svg exposing (..)
import Svg.Attributes exposing (..)


render : GameState -> Svg msg
render gameState =
  g
    []
    [ renderTimer gameState
    , renderSubStatus gameState
    ]


renderTimer : GameState -> Svg msg
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
      ms =
        floor (raceTime gameState) % 1000
    in
      if ms < 500 then
        0.5
      else
        (1000 - toFloat ms) / 500 * 0.5


getTimer : GameState -> String
getTimer { timers, playerState } =
  case timers.startTime of
    Just t ->
      let
        ( timer, showMs ) =
          case playerState.nextGate of
            Just _ ->
              -- countdown, in sec
              ( t - timers.now, False )

            Nothing ->
              -- last crossed gate time, in msec
              ( Maybe.withDefault 0 (head playerState.crossedGates), True )
      in
        formatTimer timer (isNothing playerState.nextGate)

    Nothing ->
      "START PENDING"


formatTimer : Time -> Bool -> String
formatTimer t showMs =
  let
    t' =
      t |> ceiling |> abs

    totalSeconds =
      t' // 1000

    minutes =
      totalSeconds // 60

    seconds =
      if showMs || t <= 0 then
        totalSeconds `rem` 60
      else
        (totalSeconds `rem` 60) + 1

    millis =
      t' `rem` 1000

    sMinutes =
      toString minutes

    sSeconds =
      String.padLeft 2 '0' (toString seconds)

    sMillis =
      if showMs then
        "." ++ (String.padLeft 3 '0' (toString millis))
      else
        ""
  in
    sMinutes ++ ":" ++ sSeconds ++ sMillis


renderSubStatus : GameState -> Svg msg
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
      counter =
        List.length gameState.playerState.crossedGates

      total =
        List.length gameState.course.gates + 1
    in
      if counter == total then
        "FINISHED"
      else
        "gate " ++ toString counter ++ " on " ++ toString total
  else
    ""
