module AppView where

import Html exposing (..)
import Html.Attributes exposing (..)

import Models exposing (..)
import AppTypes exposing (..)

import Screens.Home.HomeView as Home
import Screens.Login.LoginView as Login
import Screens.Register.RegisterView as Register
import Screens.ShowTrack.ShowTrackView as ShowTrack

import Views.TopBar as TopBar


view : (Int, Int) -> AppState -> Html
view (w,h) appState =
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
