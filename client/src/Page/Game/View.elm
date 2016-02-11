module Page.Game.View where

import Html exposing (..)
import Html.Attributes exposing (..)

import AppTypes exposing (..)
import Models exposing (..)

import Page.Game.Model exposing (..)
import Page.Game.ChatView as ChatView
import Page.Game.SideView as SideView

import Page.Layout as Layout

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

