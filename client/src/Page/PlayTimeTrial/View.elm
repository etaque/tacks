module Page.PlayTimeTrial.View exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Lazy
import Html.Attributes exposing (..)
import Model.Shared exposing (..)
import Page.PlayTimeTrial.Model exposing (..)
import Game.Models exposing (GameState, Timers, isStarted, raceTime)
import Game.Render.Context as GameContext
import View.Layout as Layout
import View.HexBg as HexBg
import View.Utils as Utils
import Game.Render.All as Game
import Route exposing (..)
import Constants


pageTitle : Context -> String
pageTitle ctx =
    case ctx.liveStatus.liveTimeTrial of
        Just { track } ->
            "Time trial - " ++ track.name

        _ ->
            ""


view : Context -> Model -> Layout.Game Msg
view ctx model =
    case ( ctx.liveStatus.liveTimeTrial, model.gameState ) of
        ( Just liveTimeTrial, Just gameState ) ->
            let
                ( w, h ) =
                    ctx.dims
            in
                Layout.Game
                    "play-time-trial"
                    (toolbar model liveTimeTrial gameState)
                    (sidebar model liveTimeTrial gameState)
                    (Game.render ( w - Constants.sidebarWidth, h - Constants.toolbarHeight ) gameState)

        _ ->
            Layout.Game
                "play-time-trial loading"
                []
                []
                [ Html.Lazy.lazy HexBg.render ctx.dims ]


toolbar : Model -> LiveTimeTrial -> GameState -> List (Html Msg)
toolbar model { track } gameState =
    [ div
        [ class "toolbar-left" ]
        [ Utils.linkTo
            Route.Home
            [ class "exit"
            , title "Back to home"
            ]
            [ Utils.mIcon "arrow_back" [] ]
        , h2 [] [ text track.name ]
        ]
    , div
        [ class "toolbar-center" ]
        (GameContext.raceStatus gameState StartRace ExitRace)
    , div [ class "toolbar-right" ] []
    ]


sidebar : Model -> LiveTimeTrial -> GameState -> List (Html Msg)
sidebar model liveTimeTrial gameState =
    (tabs model.tab)
        :: case model.tab of
            RankingsTab ->
                [ GameContext.rankingsBlock
                    model.ghostRuns
                    (\r -> AddGhost r.runId r.player)
                    (\r -> RemoveGhost r.runId)
                    liveTimeTrial.meta
                ]

            HelpTab ->
                [ GameContext.helpBlock ]


tabs : Tab -> Html Msg
tabs tab =
    let
        items =
            [ ( "Runs", RankingsTab )
            , ( "Help", HelpTab )
            ]
    in
        Utils.tabsRow
            items
            (\t -> onClick (SetTab t))
            ((==) tab)
