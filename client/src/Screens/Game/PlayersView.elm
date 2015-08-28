module Screens.Game.PlayersView where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Date exposing (..)
import Date.Format exposing (format)

import AppTypes exposing (..)
import Models exposing (..)
import Game.Models exposing (GameState)

import Screens.Game.Types exposing (..)
import Screens.Game.Updates exposing (actions)

import Screens.Utils exposing (..)


playersBlock : Screen -> Html
playersBlock {races, freePlayers} =
  div [ class "aside-module module-players" ]
    [ racesBlock races
    , if (List.isEmpty freePlayers) then div [] [] else freePlayersBlock freePlayers
    ]

racesBlock : List Race -> Html
racesBlock races =
  let
    isActive r = not (List.isEmpty r.players)
    activeRaces = List.filter isActive races
  in
    div [ class "list-races" ] (List.map raceItem activeRaces)

raceItem : Race -> Html
raceItem {startTime, tallies} =
  let
    formatted = fromTime startTime
      |> format "%H:%M"
  in
    div [ class "race" ]
      [ h4 [ ] [ text ("Started at " ++ formatted) ]
      , ul [ class "list-unstyled list-tallies" ] (List.indexedMap tallyItem tallies)
      ]


tallyItem : Int -> PlayerTally -> Html
tallyItem i {player, gates, finished} =
  let
    rank = toString (i + 1)
    lap = if finished then "F" else "G" ++ toString (List.length gates)
    time = Maybe.map (formatTimer True) (List.head gates)
      |> Maybe.withDefault "?"
  in
    li [ class "player" ]
      [ span [ class "rank" ] [ text rank ]
      , span [ class "time" ] [ text time ]
      , span [ class "lap"] [ text lap ]
      , span [ class "handle" ] [ text (playerHandle player) ]
      ]


freePlayersBlock : List Player -> Html
freePlayersBlock players =
  div [ class "free-players" ]
    [ h4 [ ] [ text "Free players" ]
    , ul [ class "list-unstyled list-players" ] (List.map freePlayerItem players)
    ]


freePlayerItem : Player -> Html
freePlayerItem player =
  li [ class "player" ]
    [ span [ class "handle" ] [ text (playerHandle player) ]
    ]

