module AppView where

import Html exposing (..)
import Html.Attributes exposing (..)

import Models exposing (..)
import AppTypes exposing (..)

import Screens.Home.View as Home
import Screens.Login.View as Login
import Screens.Register.View as Register
import Screens.ShowTrack.View as ShowTrack
import Screens.Game.View as Game

import Screens.TopBar as TopBar


view : (Int, Int) -> AppState -> Html
view dims appState =
  let
    content = case appState.screen of

      HomeScreen screen ->
        Home.view appState.player screen

      RegisterScreen screen ->
        Register.view screen

      LoginScreen screen ->
        Login.view screen

      ShowTrackScreen screen ->
        ShowTrack.view screen

      GameScreen screen ->
        Game.view dims screen

      _ ->
        emptyView

  in
    layout appState content


emptyView : Html
emptyView =
  div [ ] [ text "emptyView" ]


layout : AppState -> Html -> Html
layout appState content =
  div [ class "global-wrapper" ]
    [ TopBar.view appState
    , content
    ]
