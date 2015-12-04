module AppView where

import Html exposing (..)
import Html.Attributes exposing (..)
import Maybe

import Models exposing (..)
import AppTypes exposing (..)

import Screens.Home.View as HomeScreen
import Screens.Login.View as LoginScreen
import Screens.Register.View as RegisterScreen
import Screens.ShowTrack.View as ShowTrackScreen
import Screens.EditTrack.View as EditTrackScreen
import Screens.ShowProfile.View as ShowProfileScreen
import Screens.Game.View as GameScreen

import Screens.Sidebar as Sidebar
import Screens.Nav as Nav

import Constants exposing (..)
import Routes exposing (..)


view : Signal.Address AppAction -> AppState -> Html
view _ appState =
  Maybe.map (routeView appState) appState.route
    |> Maybe.withDefault emptyView
    |> layout appState


routeView : AppState -> Routes.Route -> Html
routeView {screens, player, dims} route =
  case route of

    Home ->
      HomeScreen.view player screens.home

    Register ->
      RegisterScreen.view screens.register

    Login ->
      LoginScreen.view screens.login

    ShowTrack _ ->
      ShowTrackScreen.view screens.showTrack

    EditTrack _ ->
      EditTrackScreen.view player screens.editTrack

    ShowProfile ->
      ShowProfileScreen.view screens.showProfile

    PlayTrack _ ->
      GameScreen.view dims screens.game


emptyView : Html
emptyView =
  div [ ] [ text "emptyView" ]


layout : AppState -> Html -> Html
layout appState content =
  let
    noNav = case appState.route of
      Just (EditTrack _) -> True
      Just (PlayTrack _) -> True
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
