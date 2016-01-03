module AppView where

import Html exposing (..)
import TransitRouter exposing (getTransition)

import AppTypes exposing (..)

import Screens.Home.View as HomeScreen
import Screens.Login.View as LoginScreen
import Screens.Register.View as RegisterScreen
import Screens.ShowTrack.View as ShowTrackScreen
import Screens.EditTrack.View as EditTrackScreen
import Screens.ShowProfile.View as ShowProfileScreen
import Screens.Game.View as GameScreen
import Screens.ListDrafts.View as ListDraftsScreen
import Screens.Admin.View as AdminScreen

import Routes exposing (..)


view : Signal.Address AppAction -> AppState -> Html
view _ ({screens, player, dims, routeTransition} as appState) =
  let
    ctx = Context player dims (getTransition appState) routeTransition
  in
    case (TransitRouter.getRoute appState) of

      Home ->
        HomeScreen.view ctx screens.home

      Register ->
        RegisterScreen.view ctx screens.register

      Login ->
        LoginScreen.view ctx screens.login

      ShowTrack _ ->
        ShowTrackScreen.view ctx screens.showTrack

      EditTrack _ ->
        EditTrackScreen.view ctx screens.editTrack

      ShowProfile ->
        ShowProfileScreen.view ctx screens.showProfile

      PlayTrack _ ->
        GameScreen.view ctx screens.game

      ListDrafts ->
        ListDraftsScreen.view ctx screens.listDrafts

      Admin adminRoute ->
        AdminScreen.view ctx adminRoute screens.admin

      NotFound ->
        text "Not found!"

      EmptyRoute ->
        text ""

