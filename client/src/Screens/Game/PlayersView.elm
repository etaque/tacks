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
      , ul [ class "list-unstyled list-tallies" ] (List.map tallyItem tallies)
      ]


tallyItem : PlayerTally -> Html
tallyItem {player, gates, finished} =
  let
    pos = if finished then "F" else toString (List.length gates)
    time = Maybe.map (formatTimer True) (List.head gates)
      |> Maybe.withDefault "?"
  in
    li [ class "player" ]
      [ span [ class "time" ] [ text time ]
      , span [ class "position"] [ text pos ]
      , playerWithAvatar player
      ]


freePlayersBlock : List Player -> Html
freePlayersBlock players =
  div [ class "free-players" ]
    [ h4 [ ] [ text "Free players" ]
    , ul [ class "list-unstyled list-players" ] (List.map playerItem players)
    ]


playerItem : Player -> Html
playerItem player =
  li [ class "player" ] [ playerWithAvatar player ]

