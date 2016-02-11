module Screens.Game.PlayersView where

import Html exposing (..)
import Html.Attributes exposing (..)

import Date exposing (..)
import Date.Format exposing (format)

import Models exposing (..)

import Screens.Game.Model exposing (..)

import Screens.Utils exposing (..)


block : Screen -> Html
block {races, freePlayers} =
  div [ class "aside-module module-players" ]
    [ moduleTitle "Online players"
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
      [ h4 [ ] [ text ("on race started at " ++ formatted) ]
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
      , span [ class "handle" ] [ text (playerHandle player) ]
      -- , playerWithAvatar player
      ]


freePlayersBlock : List Player -> Html
freePlayersBlock players =
  div [ class "free-players" ]
    [ h4 [] [ text "not racing"]
    , ul [ class "list-unstyled list-players" ] (List.map freePlayerItem players)
    ]


freePlayerItem : Player -> Html
freePlayerItem player =
  li [ class "player" ]
    [ playerWithAvatar player
    ]

