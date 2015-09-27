module AppView where

import Html exposing (..)
import Html.Attributes exposing (..)

import Models exposing (..)
import AppTypes exposing (..)

import Screens.Home.View as Home
import Screens.Login.View as Login
import Screens.Register.View as Register
import Screens.ShowTrack.View as ShowTrack
import Screens.EditTrack.View as EditTrack
import Screens.ShowProfile.View as ShowProfile
import Screens.Game.View as Game

import Screens.Sidebar as Sidebar
import Screens.Nav as Nav

import Constants exposing (..)


view : AppState -> Html
view appState =
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

      EditTrackScreen screen ->
        EditTrack.view screen

      ShowProfileScreen screen ->
        ShowProfile.view screen

      GameScreen screen ->
        Game.view appState.dims screen

      _ ->
        emptyView

  in
    layout appState content


emptyView : Html
emptyView =
  div [ ] [ text "emptyView" ]


layout : AppState -> Html -> Html
layout appState content =
  let
    noNav = case appState.screen of
      EditTrackScreen _ -> True
      GameScreen _ -> True
      _ -> False
  in
    if noNav then
      content
    else
      div
        [ class "content-with-nav" ]
        [ Nav.view appState
        , main' [ ] [ content ]
        ]
