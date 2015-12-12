module Screens.Game.View where

import Html exposing (..)
import Html.Attributes exposing (..)

import AppTypes exposing (..)
import Models exposing (..)

import Screens.Game.Types exposing (..)
import Screens.Game.ChatView as ChatView
import Screens.Game.SideView as SideView

import Screens.Layout as Layout

import Game.Render.All exposing (render)
import Constants exposing (..)


view : Context -> Screen -> Html
view ctx screen =
  case (screen.liveTrack, screen.gameState) of
    (Just liveTrack, Just gameState) ->
      let
        (w, h) = ctx.dims
      in
        Layout.layout "play-track"
          (SideView.view screen liveTrack gameState)
          [ div [ class "game" ]
              [ render (w - sidebarWidth, h) gameState
              , ChatView.view h screen
              ]
          ]
    _ ->
      div [ class "" ] [ ]

