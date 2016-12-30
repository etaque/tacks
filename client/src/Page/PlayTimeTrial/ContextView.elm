module Page.PlayTimeTrial.ContextView exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Model.Shared exposing (..)
import Page.PlayTimeTrial.Model exposing (..)
import Game.Shared exposing (GameState, isStarted)
import View.Utils as Utils


view : Model -> LiveTimeTrial -> GameState -> Html Msg
view model liveTimeTrial ({ playerState, course } as gameState) =
    div
        [ class "module-gate-ranking" ]
        [ trialStatusView gameState course
        , gateRankingsView model.gateRankings playerState.player course
        ]


trialStatusView : GameState -> Course -> Html Msg
trialStatusView gameState course =
    let
        gateNumber =
            List.length gameState.playerState.crossedGates

        s =
            if isStarted gameState then
                "Gate " ++ toString gateNumber ++ "/" ++ toString (List.length course.gates + 1)
            else
                "Start in progress..."
    in
        div [ class "trial-status" ] [ text s ]


gateRankingsView : List GateRanking -> Player -> Course -> Html Msg
gateRankingsView gateRankings player course =
    ul
        [ class "list-unstyled list-rankings" ]
        (List.head gateRankings
            |> Maybe.map (\r -> List.indexedMap (liveRankingLine player r.time) gateRankings)
            |> Maybe.withDefault []
        )


liveRankingLine : Player -> Float -> Int -> GateRanking -> Html Msg
liveRankingLine currentPlayer bestTime i gateRanking =
    let
        timeOrDelta =
            if i == 0 then
                Utils.formatTimer True gateRanking.time
            else
                "+" ++ (Utils.formatTimer True (gateRanking.time - bestTime))
    in
        li
            [ classList
                [ ( "ranking", True )
                , ( "current", gateRanking.isCurrent )
                ]
            ]
            [ span
                [ class "rank" ]
                [ text (toString (i + 1)) ]
            , Utils.playerWithAvatar gateRanking.player
            , span
                [ class "time" ]
                [ text timeOrDelta ]
            ]
