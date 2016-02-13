module View where

import Html exposing (..)
import TransitRouter exposing (getTransition)

import Model exposing (..)

import Page.Home.View as HomePage
import Page.Login.View as LoginPage
import Page.Register.View as RegisterPage
import Page.ShowTrack.View as ShowTrackPage
import Page.EditTrack.View as EditTrackPage
import Page.ShowProfile.View as ShowProfilePage
import Page.Game.View as GamePage
import Page.ListDrafts.View as ListDraftsPage
import Page.Forum.View as ForumPage
import Page.Admin.View as AdminPage

import Route exposing (..)


view : Signal.Address AppAction -> AppState -> Html
view _ ({screens, player, dims, routeTransition} as appState) =
  let
    ctx = Context player dims (getTransition appState) routeTransition
  in
    case (TransitRouter.getRoute appState) of

      Home ->
        HomePage.view ctx screens.home

      Register ->
        RegisterPage.view ctx screens.register

      Login ->
        LoginPage.view ctx screens.login

      ShowTrack _ ->
        ShowTrackPage.view ctx screens.showTrack

      EditTrack _ ->
        EditTrackPage.view ctx screens.editTrack

      ShowProfile ->
        ShowProfilePage.view ctx screens.showProfile

      PlayTrack _ ->
        GamePage.view ctx screens.game

      ListDrafts ->
        ListDraftsPage.view ctx screens.listDrafts

      Forum forumRoute ->
        ForumPage.view ctx forumRoute screens.forum

      Admin adminRoute ->
        AdminPage.view ctx adminRoute screens.admin

      NotFound ->
        text "Not found!"

      EmptyRoute ->
        text ""

