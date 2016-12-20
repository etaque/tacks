module Game.Widget.Rankings exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dict exposing (Dict)
import Model.Shared exposing (..)
import Game.Msg exposing (..)
import View.Utils as Utils


view : Dict String Player -> TrackMeta -> Html GameMsg
view ghostRuns meta =
    div
        [ class "aside-module module-rankings" ]
        [ ul
            [ class "list-unstyled list-rankings" ]
            (List.map (rankingItem (\runId -> Dict.member runId ghostRuns)) meta.rankings)
        , if Dict.isEmpty ghostRuns then
            div
                [ class "empty" ]
                [ text "Click on a player to add its ghost run." ]
          else
            text ""
        ]


rankingItem : (String -> Bool) -> Ranking -> Html GameMsg
rankingItem isGhost ranking =
    let
        attrs =
            if isGhost ranking.runId then
                [ class "ranking remove-ghost"
                , onClick (RemoveGhost ranking.runId)
                , title "Remove from ghosts"
                ]
            else
                [ class "ranking add-ghost"
                , onClick (AddGhost ranking.runId ranking.player)
                , title "Add to ghosts"
                ]
    in
        li
            attrs
            [ span [ class "rank" ] [ text (toString ranking.rank) ]
            , Utils.playerWithAvatar ranking.player
            , span [ class "time" ] [ text (Utils.formatTimer True ranking.finishTime) ]
            ]
