module View where

import Html exposing (..)
import TransitRouter exposing (getTransition)

import Model exposing (..)

import Page.Home.View as HomeScreen
import Page.Login.View as LoginScreen
import Page.Register.View as RegisterScreen
import Page.ShowTrack.View as ShowTrackScreen
import Page.EditTrack.View as EditTrackScreen
import Page.ShowProfile.View as ShowProfileScreen
import Page.Game.View as GameScreen
import Page.ListDrafts.View as ListDraftsScreen
import Page.Admin.View as AdminScreen

import Route exposing (..)


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

