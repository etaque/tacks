module View exposing (..)

import Html.App exposing (map)
import Html exposing (..)
import Model exposing (..)
import Model.Shared exposing (Context)
import Page.Home.View as HomePage
import Page.Login.View as LoginPage
import Page.Register.View as RegisterPage
import Page.Explore.View as ExplorePage
import Page.EditTrack.View as EditTrackPage
import Page.Game.View as GamePage
import Page.ShowTimeTrial.View as ShowTimeTrialPage
import Page.PlayTimeTrial.View as PlayTimeTrialPage
import Page.ListDrafts.View as ListDraftsPage
import Page.Forum.View as ForumPage
import Page.Admin.View as AdminPage
import Route exposing (..)
import View.Layout exposing (renderSite, renderGame)


view : Model -> Html Msg
view model =
    let
        ctx =
            Context model.player model.liveStatus model.dims model.transition model.routeJump
    in
        pageView ctx model


pageView : Context -> Model -> Html Msg
pageView ctx ({ pages, player, liveStatus, dims } as model) =
    case model.route of
        Home ->
            renderSite ctx HomeMsg (HomePage.view ctx pages.home)

        Register ->
            renderSite ctx RegisterMsg (RegisterPage.view ctx pages.register)

        Login ->
            renderSite ctx LoginMsg (LoginPage.view ctx pages.login)

        Explore ->
            renderSite ctx ExploreMsg (ExplorePage.view ctx pages.explore)

        EditTrack _ ->
            renderGame ctx EditTrackMsg (EditTrackPage.view ctx pages.editTrack)

        PlayTrack _ ->
            renderGame ctx GameMsg (GamePage.view ctx pages.game)

        ShowTimeTrial _ ->
            renderSite ctx ShowTimeTrialMsg (ShowTimeTrialPage.view ctx pages.showTimeTrial)

        PlayTimeTrial ->
            renderGame ctx PlayTimeTrialMsg (PlayTimeTrialPage.view ctx pages.playTimeTrial)

        ListDrafts ->
            renderSite ctx ListDraftsMsg (ListDraftsPage.view ctx pages.listDrafts)

        Forum forumRoute ->
            renderSite ctx ForumMsg (ForumPage.view ctx forumRoute pages.forum)

        Admin adminRoute ->
            renderSite ctx AdminMsg (AdminPage.view ctx adminRoute pages.admin)

        NotFound ->
            text "Not found!"

        EmptyRoute ->
            text "Rien"


pageTitle : Model -> String
pageTitle model =
    case model.route of
        PlayTrack _ ->
            GamePage.pageTitle model.liveStatus model.pages.game ++ " - Tacks"

        PlayTimeTrial ->
            PlayTimeTrialPage.pageTitle model.pages.playTimeTrial ++ " - Tacks"

        Home ->
            HomePage.pageTitle model.liveStatus model.pages.home ++ " - Tacks"

        _ ->
            "Tacks"
