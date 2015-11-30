module Screens.Game.View where

import Html exposing (..)
import Html.Attributes exposing (..)

import Models exposing (..)
import Game.Models exposing (GameState)

import Screens.Game.Types exposing (..)
import Screens.Game.ChatView as ChatView
import Screens.Game.SideView as SideView

import Game.Render.All exposing (render)
import Constants exposing (..)


view : Dims -> Screen -> Html
view dims screen =
  case (screen.liveTrack, screen.gameState) of
    (Just liveTrack, Just gameState) ->
      mainView dims screen liveTrack gameState
    _ ->
      div [ class "content" ] [ text "loading..." ]


mainView : Dims -> Screen -> LiveTrack -> GameState -> Html
mainView (w, h) screen liveTrack gameState =
  let
    gameSvg = render (w - sidebarWidth, h) gameState
  in
    div [ class "content" ]
      [ SideView.view h screen liveTrack gameState
      , div [ class "game" ] [ gameSvg ]
      , ChatView.view h screen
      ]

