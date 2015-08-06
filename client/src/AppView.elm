module AppView where

import Html exposing (..)

import Models exposing (..)
import AppTypes exposing (..)

import Screens.Home.HomeView as Home
import Screens.Login.LoginView as Login
import Screens.Register.RegisterView as Register

view : (Int, Int) -> AppState -> Html
view (w,h) appState =
  case appState.screen of

    HomeScreen screen ->
      Home.view appState.player screen

    RegisterScreen screen ->
      Register.view screen

    LoginScreen screen ->
      Login.view screen

    _ ->
      emptyView


emptyView : Html
emptyView =
  div [ ] [ ]
