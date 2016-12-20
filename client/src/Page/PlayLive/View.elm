module Page.PlayLive.View exposing (..)

import Html exposing (..)
import Html.Lazy
import Html.Attributes exposing (..)
import Model.Shared exposing (..)
import Page.PlayLive.Model exposing (..)
import Page.PlayLive.View.Context as Context
import Game.Msg exposing (GameMsg(ChatMsg))
import View.Layout as Layout
import View.HexBg as HexBg
import Game.Render.Chat as Chat
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
