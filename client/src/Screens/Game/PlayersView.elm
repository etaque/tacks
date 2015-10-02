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


block : Screen -> Html
block {races, freePlayers} =
  div [ class "aside-module module-players" ]
    [ h3 [] [ text "Online players" ]
    , racesBlock races
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
      [ h4 [ ] [ text ("race started at " ++ formatted) ]
      , ul [ class "list-unstyled list-tallies" ] (List.indexedMap tallyItem tallies)
      ]


tallyItem : Int -> PlayerTally -> Html
tallyItem i {player, gates, finished} =
  let
    rank = toString (i + 1)
    time = Maybe.map (formatTimer True) (List.head gates)
      |> Maybe.withDefault "?"
    status =
      if finished then
        time
      else
        "gate " ++ toString (List.length gates)
  in
    li [ class "player" ]
      [ span [ class "rank" ] [ text rank ]
      , span [ class "status" ] [ text status ]
      , playerWithAvatar player
      ]


freePlayersBlock : List Player -> Html
freePlayersBlock players =
  div [ class "free-players" ]
    [ h4 [] [ text "free players"]
    , ul [ class "list-unstyled list-players" ] (List.map freePlayerItem players)
    ]


freePlayerItem : Player -> Html
freePlayerItem player =
  li [ class "player" ]
    [ playerWithAvatar player
    ]

