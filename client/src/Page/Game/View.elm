module Page.Game.View (..) where

import Html exposing (..)
import Html.Lazy
import Html.Attributes exposing (..)
import Model.Shared exposing (..)
import Page.Game.Model exposing (..)
import Page.Game.View.Chat as Chat
import Page.Game.View.Context as Context
import View.Layout as Layout
import View.HexBg as HexBg
import Game.Render.All exposing (render)
import Constants exposing (..)


pageTitle : LiveStatus -> Model -> String
pageTitle liveStatus model =
  let
    playersCount =
      List.length model.freePlayers + (List.concatMap .players model.races |> List.length)

    trackName =
      model.liveTrack |> Maybe.map (.track >> .name) |> Maybe.withDefault ""
  in
    "(" ++ toString playersCount ++ ") " ++ trackName


view : Context -> Model -> Html
view ctx model =
  case ( model.liveTrack, model.gameState ) of
    ( Just liveTrack, Just gameState ) ->
      let
        ( w, h ) =
          ctx.dims
      in
        Layout.gameLayout
          "play-track"
          ctx
          (Context.toolbar model liveTrack gameState)
          (Context.sidebar model liveTrack gameState)
          [ render ( w - sidebarWidth, h - toolbarHeight ) gameState
          , Chat.view h model
          ]

    _ ->
      Layout.gameLayout
        "play-track loading"
        ctx
        []
        []
        [ Html.Lazy.lazy HexBg.render ctx.dims ]
