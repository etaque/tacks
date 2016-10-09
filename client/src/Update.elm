module Update exposing (..)

import Task exposing (Task)
import Result
import Response exposing (..)
import Update.Utils exposing (..)
import Model exposing (..)
import Page.Home.Update as Home
import Page.Register.Update as Register
import Page.Login.Update as Login
import Page.Explore.Update as Explore
import Page.EditTrack.Update as EditTrack
import Page.Game.Update as Game
import Page.ShowTimeTrial.Update as ShowTimeTrial
import Page.PlayTimeTrial.Update as PlayTimeTrial
import Page.ListDrafts.Update as ListDrafts
import Page.Forum.Update as Forum
import Page.Admin.Update as Admin
import ServerApi
import Route exposing (..)
import Model.Event as Event exposing (Event)
import Time
import Window
import Transit
import Navigation
import Json.Encode as Js
import Json.Decode as Json
import WebSocket
import Activity


subscriptions : Model -> Sub Msg
subscriptions ({ pages } as model) =
    let
        pageSub =
            case model.route of
                Home ->
                    Sub.map HomeMsg (Home.subscriptions model.host pages.home)

                Explore ->
                    Sub.map ExploreMsg (Explore.subscriptions pages.explore)

                PlayTrack _ ->
                    Sub.map GameMsg (Game.subscriptions model.host pages.game)

                PlayTimeTrial ->
                    Sub.map PlayTimeTrialMsg (PlayTimeTrial.subscriptions model.host pages.playTimeTrial)

                EditTrack _ ->
                    Sub.map EditTrackMsg (EditTrack.subscriptions pages.editTrack)

                _ ->
                    Sub.none
    in
        Sub.batch
            [ Time.every Time.second (\_ -> ActivityEmitMsg Activity.Ping)
            , WebSocket.listen
                (ServerApi.activitySocket model.host)
                ActivityRawReceive
            , Window.resizes WindowResized
            , Sub.map PageMsg pageSub
            , Transit.subscriptions RouteTransition model
            ]


init : Setup -> Route -> ( Model, Cmd Msg )
init setup route =
    urlUpdate route (initialModel setup)


eventMsg : Event -> Msg
eventMsg event =
    case event of
        Event.SetPlayer p ->
            SetPlayer p

        Event.Poke p ->
            ActivityEmitMsg (Activity.Poke p)


update : Msg -> Model -> ( Model, Cmd Msg )
update =
    Response.updateWithEvent eventMsg msgUpdate


msgUpdate : Msg -> Model -> Response Model Msg
msgUpdate msg ({ pages } as model) =
    case msg of
        ActivityEmitMsg emitMsg ->
            let
                raw =
                    Js.encode 0 (Activity.encodeEmitMsg emitMsg)
            in
                res model (WebSocket.send (ServerApi.activitySocket model.host) raw)

        ActivityRawReceive rawMsg ->
            case Json.decodeString Activity.receiveMsgDecoder rawMsg of
                Ok receiveMsg ->
                    case receiveMsg of
                        Activity.PokedBy player ->
                            res model (Activity.notifyPokedBy player)

                        Activity.RefreshLiveStatus liveStatus ->
                            res { model | liveStatus = liveStatus } Cmd.none

                Err _ ->
                    res model Cmd.none

        SetPlayer p ->
            res { model | player = p } (navigate Route.Home)

        RouteTransition subMsg ->
            Transit.tick RouteTransition subMsg model
                |> toResponse

        MountRoute new ->
            mountRoute new model

        WindowResized size ->
            res { model | dims = ( size.width, size.height ) } Cmd.none

        Logout ->
            ServerApi.postLogout
                |> Task.map (Result.toMaybe >> Maybe.map SetPlayer >> Maybe.withDefault NoOp)
                |> performSucceed identity
                |> res model

        PageMsg pageMsg ->
            pageUpdate pageMsg model

        Navigate path ->
            res model (Navigation.newUrl path)

        NoOp ->
            res model Cmd.none


urlUpdate : Route -> Model -> ( Model, Cmd Msg )
urlUpdate route model =
    Transit.start RouteTransition (MountRoute route) ( 50, 200 ) model


mountRoute : Route -> Model -> Response Model Msg
mountRoute newRoute ({ pages, player, route } as prevModel) =
    let
        routeJump =
            Route.detectJump route newRoute

        model =
            { prevModel | routeJump = routeJump, route = newRoute }
    in
        case newRoute of
            Home ->
                applyHome (Home.mount pages.home) model

            Login ->
                applyLogin Login.mount model

            Register ->
                applyRegister Register.mount model

            Explore ->
                applyExplore Explore.mount model

            EditTrack id ->
                applyEditTrack (EditTrack.mount id) model

            PlayTrack id ->
                applyGame (Game.mount id) model

            ShowTimeTrial id ->
                applyShowTimeTrial (ShowTimeTrial.mount id) model

            PlayTimeTrial ->
                applyPlayTimeTrial PlayTimeTrial.mount model

            ListDrafts ->
                applyListDrafts (ListDrafts.mount pages.listDrafts) model

            Forum forumRoute ->
                applyForum (Forum.mount forumRoute) model

            Admin adminRoute ->
                applyAdmin Admin.mount model

            _ ->
                res model Cmd.none


pageUpdate : PageMsg -> Model -> Response Model Msg
pageUpdate pageMsg ({ pages, player, dims } as model) =
    case pageMsg of
        HomeMsg a ->
            applyHome (Home.update model.host player a pages.home) model

        LoginMsg a ->
            applyLogin (Login.update a pages.login) model

        RegisterMsg a ->
            applyRegister (Register.update a pages.register) model

        ExploreMsg a ->
            applyExplore (Explore.update a pages.explore) model

        EditTrackMsg a ->
            applyEditTrack (EditTrack.update dims a pages.editTrack) model

        GameMsg a ->
            applyGame (Game.update player model.host a pages.game) model

        ShowTimeTrialMsg a ->
            applyShowTimeTrial (ShowTimeTrial.update player a pages.showTimeTrial) model

        PlayTimeTrialMsg a ->
            applyPlayTimeTrial (PlayTimeTrial.update player model.host a pages.playTimeTrial) model

        ListDraftsMsg a ->
            applyListDrafts (ListDrafts.update a pages.listDrafts) model

        ForumMsg a ->
            applyForum (Forum.update a pages.forum) model

        AdminMsg a ->
            applyAdmin (Admin.update a pages.admin) model


applyHome =
    applyPage (\s pages -> { pages | home = s }) HomeMsg


applyLogin =
    applyPage (\s pages -> { pages | login = s }) LoginMsg


applyRegister =
    applyPage (\s pages -> { pages | register = s }) RegisterMsg


applyExplore =
    applyPage (\s pages -> { pages | explore = s }) ExploreMsg


applyEditTrack =
    applyPage (\s pages -> { pages | editTrack = s }) EditTrackMsg


applyGame =
    applyPage (\s pages -> { pages | game = s }) GameMsg


applyShowTimeTrial =
    applyPage (\s pages -> { pages | showTimeTrial = s }) ShowTimeTrialMsg


applyPlayTimeTrial =
    applyPage (\s pages -> { pages | playTimeTrial = s }) PlayTimeTrialMsg


applyListDrafts =
    applyPage (\s pages -> { pages | listDrafts = s }) ListDraftsMsg


applyForum =
    applyPage (\s pages -> { pages | forum = s }) ForumMsg


applyAdmin =
    applyPage (\s pages -> { pages | admin = s }) AdminMsg


applyPage : (model -> Pages -> Pages) -> (msg -> PageMsg) -> Response model msg -> Model -> Response Model Msg
applyPage pagesUpdater msgWrapper response model =
    response
        |> mapModel (\p -> { model | pages = pagesUpdater p model.pages })
        |> mapCmd (msgWrapper >> PageMsg)
