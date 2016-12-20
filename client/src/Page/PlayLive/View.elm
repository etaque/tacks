module Page.PlayLive.View exposing (..)

import Html exposing (..)
import Html.Lazy
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Page.PlayLive.Model exposing (..)
import Game.Msg exposing (GameMsg(ChatMsg))
import View.Layout as Layout
import View.HexBg as HexBg
import Game.Render.All exposing (render)
import Game.Widget.Timer as Timer
import Game.Widget.Help as Help
import Game.Widget.Rankings as Rankings
import Game.Widget.LivePlayers as LivePlayers
import Game.Widget.Chat as Chat
import Constants
import Game.Shared exposing (GameState)
import View.Utils as Utils
import Route


pageTitle : LiveStatus -> Model -> String
pageTitle liveStatus model =
    let
        playersCount =
            List.length model.freePlayers + (List.concatMap .players model.races |> List.length)

        trackName =
            model.liveTrack
                |> dataMaybe
                |> Maybe.map (.track >> .name)
                |> Maybe.withDefault ""
    in
        "(" ++ toString playersCount ++ ") " ++ trackName


view : Context -> Model -> Layout.Game Msg
view { layout } model =
    case ( model.liveTrack, model.gameState ) of
        ( DataOk liveTrack, Just gameState ) ->
            Layout.Game
                "play-track"
                (appbar model liveTrack gameState)
                (sidebar model liveTrack gameState)
                [ render ( layout.size.width, layout.size.height - Constants.appbarHeight ) gameState
                , Html.map (GameMsg << ChatMsg) (Chat.inputField model.chat)
                  -- , Context.touch model liveTrack gameState
                ]

        _ ->
            Layout.Game
                "play-track loading"
                []
                []
                [ Html.Lazy.lazy HexBg.render layout.size ]


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
        [ Html.map GameMsg (Timer.view gameState) ]
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
                (Route.EditTrack track.id)
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
                [ LivePlayers.view model.races model.freePlayers
                , Html.map (GameMsg << ChatMsg) (Chat.messages model.chat)
                ]

            RankingsTab ->
                [ Html.map GameMsg
                    (Rankings.view model.ghostRuns liveTrack.meta)
                ]

            HelpTab ->
                [ Help.view ]


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
