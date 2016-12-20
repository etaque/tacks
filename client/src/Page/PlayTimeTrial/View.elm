module Page.PlayTimeTrial.View exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Lazy
import Html.Attributes exposing (..)
import Model.Shared exposing (..)
import Page.PlayTimeTrial.Model exposing (..)
import Game.Shared exposing (GameState, Timers, isStarted, raceTime)
import Game.Msg exposing (..)
import Game.Widget.Timer as Timer
import Game.Widget.Help as Help
import Game.Widget.Rankings as Rankings
import View.Layout as Layout
import View.HexBg as HexBg
import View.Utils as Utils
import Game.Render.All exposing (render)
import Route exposing (..)
import Constants exposing (..)


pageTitle : Context -> String
pageTitle ctx =
    case ctx.liveStatus.liveTimeTrial of
        Just { track } ->
            "Time trial - " ++ track.name

        _ ->
            ""


view : Context -> Model -> Layout.Game Msg
view { layout, liveStatus } model =
    case ( liveStatus.liveTimeTrial, model.gameState ) of
        ( Just liveTimeTrial, Just gameState ) ->
            Layout.Game
                "play-time-trial"
                (appbar model liveTimeTrial gameState)
                (sidebar model liveTimeTrial gameState)
                [ render ( layout.size.width, layout.size.height - appbarHeight ) gameState
                ]

        _ ->
            Layout.Game
                "play-time-trial loading"
                []
                []
                [ Html.Lazy.lazy HexBg.render layout.size ]


appbar : Model -> LiveTimeTrial -> GameState -> List (Html Msg)
appbar model { track } gameState =
    [ div
        [ class "appbar-left" ]
        [ Utils.linkTo
            Route.Home
            [ class "exit"
            , title "Back to home"
            ]
            [ Utils.mIcon "arrow_back" [] ]
        , h2 [] [ text track.name ]
        ]
    , div
        [ class "appbar-center" ]
        [ Html.map GameMsg (Timer.view gameState) ]
    , div [ class "appbar-right" ] []
    ]


sidebar : Model -> LiveTimeTrial -> GameState -> List (Html Msg)
sidebar model liveTimeTrial gameState =
    tabs model.tab
        :: case model.tab of
            RankingsTab ->
                [ Html.map GameMsg
                    (Rankings.view model.ghostRuns liveTimeTrial.meta)
                ]

            HelpTab ->
                [ Help.view ]


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
