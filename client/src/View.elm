module View exposing (..)

import Html exposing (..)
import Model exposing (..)
import Model.Shared exposing (Context)
import Page.Home.View as HomePage
import Page.Login.View as LoginPage
import Page.Register.View as RegisterPage
import Page.Explore.View as ExplorePage
import Page.EditTrack.View as EditTrackPage
import Page.PlayLive.View as PlayLivePage
import Page.ShowTimeTrial.View as ShowTimeTrialPage
import Page.PlayTimeTrial.View as PlayTimeTrialPage
import Page.ListDrafts.View as ListDraftsPage
import Page.Forum.View as ForumPage
import Page.Admin.View as AdminPage
import Route exposing (..)
import View.Layout exposing (render)


view : Model -> Html Msg
view ({ pages, player, liveStatus, device, transition, routeJump } as model) =
    let
        ctx =
            Context player liveStatus device transition routeJump
    in
        case model.route of
            Home ->
                render ctx HomeMsg (HomePage.view ctx pages.home)

            Register ->
                render ctx RegisterMsg (RegisterPage.view ctx pages.register)

            Login ->
                render ctx LoginMsg (LoginPage.view ctx pages.login)

            Explore ->
                render ctx ExploreMsg (ExplorePage.view ctx pages.explore)

            EditTrack _ ->
                render ctx EditTrackMsg (EditTrackPage.view ctx pages.editTrack)

            PlayTrack _ ->
                render ctx PlayLiveMsg (PlayLivePage.view ctx pages.game)

            ShowTimeTrial _ ->
                render ctx ShowTimeTrialMsg (ShowTimeTrialPage.view ctx pages.showTimeTrial)

            PlayTimeTrial ->
                render ctx PlayTimeTrialMsg (PlayTimeTrialPage.view ctx pages.playTimeTrial)

            ListDrafts ->
                render ctx ListDraftsMsg (ListDraftsPage.view ctx pages.listDrafts)

            Forum forumRoute ->
                render ctx ForumMsg (ForumPage.view ctx forumRoute pages.forum)

            Admin adminRoute ->
                render ctx AdminMsg (AdminPage.view ctx adminRoute pages.admin)

            NotFound ->
                text "Not found!"

            EmptyRoute ->
                text ""


pageTitle : Context -> Model -> String
pageTitle ctx model =
    case model.route of
        PlayTrack _ ->
            PlayLivePage.pageTitle model.liveStatus model.pages.game ++ " - Tacks"

        PlayTimeTrial ->
            PlayTimeTrialPage.pageTitle ctx ++ " - Tacks"

        Home ->
            HomePage.pageTitle model.liveStatus model.pages.home ++ " - Tacks"

        _ ->
            "Tacks"
