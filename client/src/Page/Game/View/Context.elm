module Page.Game.View.Context exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Game.Models exposing (GameState, Timers, isStarted, raceTime)
import Game.Render.Context as GameContext
import Page.Game.Model exposing (..)
import Page.Game.View.Players as PlayersView
import Page.Game.Chat.View as Chat
import View.Utils as Utils
import Route exposing (..)
import Game.Touch as Touch
import TouchEvents


appbar : Model -> LiveTrack -> GameState -> List (Html Msg)
appbar model { track } gameState =
    [ div
        [ class "appbar-left" ]
        [ if track.status == Draft then
            Utils.linkTo
                (Route.EditTrack track.id)
                [ class "exit"
                , title "Back to editor"
                ]
                [ Utils.mIcon "close" [] ]
          else
            Utils.linkTo
                Route.Home
                [ class "exit"
                , title "Back to home"
                ]
                [ Utils.mIcon "arrow_back" [] ]
        , h2 [] [ text track.name ]
        ]
    , div
        [ class "appbar-center" ]
        (GameContext.raceStatus gameState StartRace ExitRace)
    , div [ class "appbar-right" ] []
    ]


sidebar : Model -> LiveTrack -> GameState -> List (Html Msg)
sidebar model liveTrack gameState =
    let
        blocks =
            if liveTrack.track.status == Draft then
                draftBlocks liveTrack
            else
                liveBlocks gameState model liveTrack
    in
        blocks


trackNav : LiveTrack -> Html Msg
trackNav liveTrack =
    div
        [ class "track-menu" ]
        [ h2 [] [ text liveTrack.track.name ] ]


draftBlocks : LiveTrack -> List (Html Msg)
draftBlocks { track } =
    [ div
        [ class "draft" ]
        [ div
            [ class "actions" ]
            [ Utils.linkTo
                (EditTrack track.id)
                [ class "btn-raised btn-primary" ]
                [ Utils.mIcon "edit" [], text "Edit draft" ]
            ]
        , p
            []
            [ text "This is a draft, you're the only one seeing this race track." ]
        ]
    ]


liveBlocks : GameState -> Model -> LiveTrack -> List (Html Msg)
liveBlocks gameState model liveTrack =
    (tabs model)
        :: case model.tab of
            NoTab ->
                []

            LiveTab ->
                [ PlayersView.block model
                , Html.map ChatMsg (Chat.messages model.chat)
                ]

            RankingsTab ->
                [ GameContext.rankingsBlock
                    model.ghostRuns
                    (\r -> AddGhost r.runId r.player)
                    (\r -> RemoveGhost r.runId)
                    liveTrack.meta
                ]

            HelpTab ->
                [ GameContext.helpBlock ]


tabs : Model -> Html Msg
tabs { tab } =
    let
        items =
            [ ( "Live", LiveTab )
            , ( "Runs", RankingsTab )
            , ( "Help", HelpTab )
            ]

        setTab t =
            if t == tab then
                SetTab NoTab
            else
                SetTab t
    in
        Utils.tabsRow
            items
            (\t -> onClick (setTab t))
            ((==) tab)


touch : Model -> LiveTrack -> GameState -> Html Msg
touch model liveTrack gameState =
    div
        [ class "touch-commands" ]
        [ div
            [ class "touch-panel-left" ]
            [ a
                [ class "touch-left"
                , TouchEvents.onTouchStart (\_ -> TouchMsg (Touch.Turn -1))
                , TouchEvents.onTouchEnd (\_ -> TouchMsg (Touch.Turn 0))
                ]
                [ Utils.mIcon "chevron_left" []
                ]
            , a
                [ class "touch-subtle-left"
                , TouchEvents.onTouchStart (\_ -> TouchMsg (Touch.SubtleTurn -1))
                , TouchEvents.onTouchEnd (\_ -> TouchMsg (Touch.SubtleTurn 0))
                ]
                [ Utils.mIcon "chevron_left" []
                ]
            ]
        , div
            [ class "touch-panel-center" ]
            []
        , div
            [ class "touch-panel-right" ]
            [ a
                [ class "touch-right"
                , TouchEvents.onTouchStart (\_ -> TouchMsg (Touch.Turn 1))
                , TouchEvents.onTouchEnd (\_ -> TouchMsg (Touch.Turn 0))
                ]
                [ Utils.mIcon "chevron_right" []
                ]
            , a
                [ class "touch-subtle-right"
                , TouchEvents.onTouchStart (\_ -> TouchMsg (Touch.SubtleTurn 1))
                , TouchEvents.onTouchEnd (\_ -> TouchMsg (Touch.SubtleTurn 0))
                ]
                [ Utils.mIcon "chevron_right" []
                ]
            ]
        ]
