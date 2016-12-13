module Page.Game.View exposing (..)

import Html exposing (..)
import Html.Lazy
import Html.Attributes exposing (..)
import Model.Shared exposing (..)
import Page.Game.Model exposing (..)
import Page.Game.Chat.View as Chat
import Page.Game.View.Context as Context
import View.Layout as Layout
import View.HexBg as HexBg
import Game.Render.All exposing (render)
import Constants


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
                (Context.appbar model liveTrack gameState)
                (Context.sidebar model liveTrack gameState)
                [ render ( layout.size.width - Constants.sidebarWidth, layout.size.height - Constants.appbarHeight ) gameState
                , Html.map ChatMsg (Chat.inputField model.chat)
                ]
                [ Context.touchbar model liveTrack gameState ]

        _ ->
            Layout.Game
                "play-track loading"
                []
                []
                [ Html.Lazy.lazy HexBg.render layout.size ]
                []
