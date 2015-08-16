module Screens.Game.PlayersView where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

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
    , ul [ class "list-unstyled list-players" ] (List.map playerItem freePlayers)
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
  div [ class "race" ]
    [ text (toString startTime)
    , ul [ class "list-unstyled list-tallies" ] (List.map tallyItem tallies)
    ]


tallyItem : PlayerTally -> Html
tallyItem {player, gates} =
  playerItem player


playerItem : Player -> Html
playerItem player =
  li [ class "player" ] [ playerWithAvatar player ]

