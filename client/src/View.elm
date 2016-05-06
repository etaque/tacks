module View (..) where

import Html exposing (..)
import TransitRouter exposing (getTransition)
import Model exposing (..)
import Model.Shared exposing (Context)
import Page.Home.View as HomePage
import Page.Login.View as LoginPage
import Page.Register.View as RegisterPage
import Page.Explore.View as ExplorePage
import Page.EditTrack.View as EditTrackPage
import Page.Game.View as GamePage
import Page.ListDrafts.View as ListDraftsPage
import Page.Forum.View as ForumPage
import Page.Admin.View as AdminPage
import Route exposing (..)


view : Signal.Address Action -> Model -> Html
view _ ({ pages, player, liveStatus, dims, routeTransition } as model) =
  let
    ctx =
      Context player liveStatus dims (getTransition model) routeTransition
  in
    case (TransitRouter.getRoute model) of
      Home ->
        HomePage.view ctx pages.home

      Register ->
        RegisterPage.view ctx pages.register

      Login ->
        LoginPage.view ctx pages.login

      Explore ->
        ExplorePage.view ctx pages.explore

      EditTrack _ ->
        EditTrackPage.view ctx pages.editTrack

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


pageTitle : Model -> String
pageTitle model =
  case TransitRouter.getRoute model of
    PlayTrack _ ->
      GamePage.pageTitle model.liveStatus model.pages.game ++ " - Tacks"

    Home ->
      HomePage.pageTitle model.liveStatus model.pages.home ++ " - Tacks"

    _ ->
      "Tacks"
