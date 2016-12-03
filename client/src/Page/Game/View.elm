module Page.Game.View exposing (..)

import Html exposing (..)
import Html.Lazy as Lazy
import Html.Attributes exposing (..)
import Model.Shared exposing (..)
import Page.Game.Model exposing (..)
import Page.Game.Chat.View as Chat
import Page.Game.View.Context as Context
import View.Layout as Layout
import View.HexBg as HexBg
import Game.Render.All as Game
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
view ctx model =
    case ( model.liveTrack, model.gameState ) of
        ( DataOk liveTrack, Just gameState ) ->
            let
                ( w, h ) =
                    ctx.dims
            in
                Layout.Game
                    "play-track"
                    (Context.toolbar model liveTrack gameState)
                    (Context.sidebar model liveTrack gameState)
                <|
                    (Game.render ( w - Constants.sidebarWidth, h - Constants.toolbarHeight ) gameState)
                        ++ [ Html.map ChatMsg (Chat.inputField model.chat) ]

        _ ->
            Layout.Game
                "play-track loading"
                []
                []
                [ Lazy.lazy HexBg.render ctx.dims ]
