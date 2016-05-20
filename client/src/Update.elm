module Update exposing (..)

import Task exposing (Task)
import Result
import Response exposing (..)
import Model exposing (..)
import Page.Home.Update as Home
import Page.Register.Update as Register
import Page.Login.Update as Login
import Page.Explore.Update as Explore
import Page.EditTrack.Update as EditTrack
-- import Page.Game.Update as Game
import Page.ListDrafts.Update as ListDrafts
import Page.Forum.Update as Forum
import Page.Admin.Update as Admin
import ServerApi
import Route exposing (..)
import Location
import Model.Event as Event exposing (Event)
import CoreExtra exposing (..)
import Time
import Window


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Location.subscriptions LocationMsg model.location
    , Time.every (Time.second * 5) (\_ -> RefreshLiveStatus)
    , Window.resizes WindowResized
    ]


init : Setup -> ( Model, Cmd Msg )
init setup =
  let
    ( model, cmd ) =
      update (LocationMsg (Location.PathUpdated setup.path)) (initialModel setup)
  in
    ( model, Cmd.batch [ cmd, refreshLiveStatus ] )


eventMsg : Event -> Msg
eventMsg event =
  case event of
    Event.SetPlayer p ->
      SetPlayer p

    Event.MountRoute prev new ->
      MountRoute prev new


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  let
    msgResponse =
      msgUpdate msg model

    eventResponse =
      case msgResponse.event of
        Just event ->
          msgUpdate (eventMsg event) msgResponse.model

        Nothing ->
          res msgResponse.model Cmd.none
  in
    ( eventResponse.model, Cmd.batch [ msgResponse.cmd, eventResponse.cmd ] )


msgUpdate : Msg -> Model -> Response Model Msg
msgUpdate msg ({ pages } as model) =
  case msg of
    LocationMsg m ->
      Location.update m model.location
        |> mapBoth (\l -> { model | location = l }) LocationMsg

    RefreshLiveStatus ->
      res model refreshLiveStatus

    SetLiveStatus result ->
      let
        liveStatus =
          Result.withDefault model.liveStatus result
      in
        res { model | liveStatus = liveStatus } Cmd.none

    SetPlayer p ->
      res { model | player = p } (Location.navigate Route.Home)

    MountRoute prev new ->
      mountRoute prev new model

    WindowResized size ->
      res { model | dims = (size.width, size.height) } Cmd.none

    Logout ->
      res model Cmd.none
      -- TODO res model (Task.perform NoOp SetPlayer ServerApi.postLogout)
      -- Task.perform (\_ -> NoOp) SetPlayer 

    PageMsg pageMsg ->
      pageUpdate pageMsg model

    NoOp ->
      res model Cmd.none


mountRoute : Route -> Route -> Model -> Response Model Msg
mountRoute prevRoute newRoute ({ pages, player } as model) =
  -- let
  --   routeTransition =
  --     Route.detectTransition prevRoute newRoute

  --   model =
  --     { prevModel | routeTransition = routeTransition }
  -- in
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

      -- TODO PlayTrack id ->
        -- applyGame (Game.mount id) model

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
      applyHome (Home.update a pages.home) model

    LoginMsg a ->
      applyLogin (Login.update a pages.login) model

    RegisterMsg a ->
      applyRegister (Register.update a pages.register) model

    ExploreMsg a ->
      applyExplore (Explore.update a pages.explore) model

    EditTrackMsg a ->
      applyEditTrack (EditTrack.update dims a pages.editTrack) model

    GameMsg a ->
      -- TODO applyGame (Game.update player a pages.game) model
      res model Cmd.none

    ListDraftsMsg a ->
      applyListDrafts (ListDrafts.update a pages.listDrafts) model

    ForumMsg a ->
      applyForum (Forum.update a pages.forum) model

    AdminMsg a ->
      applyAdmin (Admin.update a pages.admin) model


-- logoutCmd : Task Cmd.Never Msg
-- logoutCmd =


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


refreshLiveStatus : Cmd Msg
refreshLiveStatus =
  ServerApi.getLiveStatus
    |> Task.perform never SetLiveStatus
