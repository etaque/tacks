module Update exposing (..)

import Result
import Response exposing (..)
import Update.Utils exposing (..)
import Model exposing (..)
import Page.Home.Update as Home
import Page.Register.Update as Register
import Page.Login.Update as Login
import Page.Explore.Update as Explore
import Page.EditTrack.Update as EditTrack
import Page.PlayLive.Update as PlayLive
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
import Navigation
import Ports


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
                    Sub.map PlayLiveMsg (PlayLive.subscriptions model.host pages.game)

                PlayTimeTrial ->
                    Sub.map PlayTimeTrialMsg (PlayTimeTrial.subscriptions model.host model.liveStatus pages.playTimeTrial)

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


init : Setup -> Navigation.Location -> ( Model, Cmd Msg )
init setup location =
    askRoute (Route.parser location) (initialModel setup)


eventMsg : Event -> Msg
eventMsg event =
    case event of
        Event.SetPlayer p ->
            SetPlayer p

        Event.Poke p ->
            ActivityEmitMsg (Activity.Poke p)

        Event.SetDeviceControl deviceControl ->
            SetDeviceControl deviceControl


update : Msg -> Model -> ( Model, Cmd Msg )
update =
    Response.updateWithEvent eventMsg msgUpdate


msgUpdate : Msg -> Model -> Response Model Msg
msgUpdate msg ({ device, pages } as model) =
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

        AskRoute route ->
            askRoute route model
                |> toResponse

        RouteTransition subMsg ->
            Transit.tick RouteTransition subMsg model
                |> toResponse

        MountRoute new ->
            mountRoute new model

        WindowResized size ->
            res { model | device = { device | size = size } } Cmd.none

        Logout ->
            ServerApi.postLogout
                |> ServerApi.sendForm (Result.toMaybe >> Maybe.map SetPlayer >> Maybe.withDefault NoOp)
                |> res model

        PageMsg pageMsg ->
            pageUpdate pageMsg model

        Navigate path ->
            res model (Navigation.newUrl path)

        ToggleSidebar visible ->
            res { model | device = { device | showMenu = visible } } Cmd.none

        SetDeviceControl deviceControl ->
            res
                { model | device = { device | control = deviceControl } }
                (Ports.saveControl (toString deviceControl))

        NoOp ->
            res model Cmd.none


askRoute : Route -> Model -> ( Model, Cmd Msg )
askRoute route model =
    Transit.start RouteTransition (MountRoute route) ( 50, 200 ) model


mountRoute : Route -> Model -> Response Model Msg
mountRoute newRoute ({ pages, player, route, device } as prevModel) =
    let
        routeJump =
            Route.detectJump route newRoute

        model =
            { prevModel
                | routeJump = routeJump
                , route = newRoute
                , device = { device | showMenu = False }
            }
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
                applyPlayLive (PlayLive.mount device id) model

            ShowTimeTrial id ->
                applyShowTimeTrial (ShowTimeTrial.mount id) model

            PlayTimeTrial ->
                applyPlayTimeTrial (PlayTimeTrial.mount device model.liveStatus) model

            ListDrafts ->
                applyListDrafts (ListDrafts.mount pages.listDrafts) model

            Forum forumRoute ->
                applyForum (Forum.mount forumRoute) model

            Admin adminRoute ->
                applyAdmin Admin.mount model

            _ ->
                res model Cmd.none


pageUpdate : PageMsg -> Model -> Response Model Msg
pageUpdate pageMsg ({ pages, player, device } as model) =
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
            applyEditTrack (EditTrack.update device.size a pages.editTrack) model

        PlayLiveMsg a ->
            applyPlayLive (PlayLive.update player model.host a pages.game) model

        ShowTimeTrialMsg a ->
            applyShowTimeTrial (ShowTimeTrial.update player a pages.showTimeTrial) model

        PlayTimeTrialMsg a ->
            applyPlayTimeTrial (PlayTimeTrial.update model.liveStatus player model.host a pages.playTimeTrial) model

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


applyPlayLive =
    applyPage (\s pages -> { pages | game = s }) PlayLiveMsg


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
