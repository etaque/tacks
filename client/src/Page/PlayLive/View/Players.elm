module Page.PlayLive.View.Players exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date exposing (..)
import Date.Format exposing (format)
import Model.Shared exposing (..)
import Page.PlayLive.Model exposing (..)
import View.Utils as Utils


block : Model -> Html Msg
block { races, freePlayers } =
    div
        [ class "aside-module module-players" ]
        [ if (List.isEmpty freePlayers) then
            div [] []
          else
            freePlayersBlock freePlayers
        , racesBlock races
        ]


racesBlock : List Race -> Html Msg
racesBlock races =
    let
        isActive r =
            not (List.isEmpty r.players)

        activeRaces =
            List.filter isActive races
    in
        div [ class "list-races" ] (List.map raceItem activeRaces)


raceItem : Race -> Html Msg
raceItem { startTime, tallies } =
    let
        formatted =
            fromTime startTime
                |> format "%H:%M"
    in
        div
            [ class "race" ]
            [ div [ class "race-legend" ] [ text ("Race started at " ++ formatted) ]
            , ul [ class "list-unstyled list-rankings" ] (List.indexedMap tallyItem tallies)
            ]


tallyItem : Int -> PlayerTally -> Html Msg
tallyItem i { player, gates, finished } =
    let
        rank =
            toString (i + 1)

        time =
            Maybe.map (Utils.formatTimer True) (List.head gates)
                |> Maybe.withDefault "?"

        status =
            if finished then
                time
            else
                "gate " ++ toString (List.length gates)
    in
        li
            [ class "player" ]
            [ span [ class "rank" ] [ text rank ]
            , span [ class "time" ] [ text status ]
            , Utils.playerWithAvatar player
            ]


freePlayersBlock : List Player -> Html Msg
freePlayersBlock players =
    div
        [ class "free-players" ]
        [ ul [ class "list-unstyled list-players" ] (List.map freePlayerItem players)
        ]


freePlayerItem : Player -> Html Msg
freePlayerItem player =
    li
        [ class "player" ]
        [ Utils.playerWithAvatar player ]
