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
view _ ({pages, player, dims, routeTransition} as appState) =
  let
    ctx = Context player dims (getTransition appState) routeTransition
  in
    case (TransitRouter.getRoute appState) of

      Home ->
        HomePage.view ctx pages.home

      Register ->
        RegisterPage.view ctx pages.register

      Login ->
        LoginPage.view ctx pages.login

      ShowTrack _ ->
        ShowTrackPage.view ctx pages.showTrack

      EditTrack _ ->
        EditTrackPage.view ctx pages.editTrack

      ShowProfile ->
        ShowProfilePage.view ctx pages.showProfile

      PlayTrack _ ->
        GamePage.view ctx pages.game

      ListDrafts ->
        ListDraftsPage.view ctx pages.listDrafts

      Forum forumRoute ->
        ForumPage.view ctx forumRoute pages.forum

      Admin adminRoute ->
        AdminPage.view ctx adminRoute pages.admin

      NotFound ->
        text "Not found!"

      EmptyRoute ->
        text ""

