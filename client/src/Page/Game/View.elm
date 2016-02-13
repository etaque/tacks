module Page.Game.View where

import Html exposing (..)
import Html.Attributes exposing (..)

import Model exposing (..)
import Model.Shared exposing (..)

import Page.Game.Model exposing (..)
import Page.Game.ChatView as ChatView
import Page.Game.SideView as SideView

import View.Layout as Layout

import Game.Render.All exposing (render)
import Constants exposing (..)


view : Context -> Model -> Html
view ctx model =
  case (model.liveTrack, model.gameState) of
    (Just liveTrack, Just gameState) ->
      let
        (w, h) = ctx.dims
      in
        Layout.layout "play-track"
          (SideView.view model liveTrack gameState)
          [ div [ class "game" ]
              [ render (w - sidebarWidth, h) gameState
              , ChatView.view h model
              ]
          ]
    _ ->
      div [ class "" ] [ ]

