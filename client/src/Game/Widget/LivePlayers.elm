module Game.Widget.LivePlayers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date exposing (..)
import Date.Format exposing (format)
import Model.Shared exposing (..)
import View.Utils as Utils


view : List Race -> List Player -> Html msg
view races freePlayers =
    div
        [ class "aside-module module-players" ]
        [ if (List.isEmpty freePlayers) then
            div [] []
          else
            freePlayersBlock freePlayers
        , racesBlock races
        ]


racesBlock : List Race -> Html msg
racesBlock races =
    let
        isActive r =
            not (List.isEmpty r.players)

        activeRaces =
            List.filter isActive races
    in
        div [ class "list-races" ] (List.map raceItem activeRaces)


raceItem : Race -> Html msg
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


tallyItem : Int -> PlayerTally -> Html msg
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


freePlayersBlock : List Player -> Html msg
freePlayersBlock players =
    div
        [ class "free-players" ]
        [ ul [ class "list-unstyled list-players" ] (List.map freePlayerItem players)
        ]


freePlayerItem : Player -> Html msg
freePlayerItem player =
    li
        [ class "player" ]
        [ Utils.playerWithAvatar player ]
