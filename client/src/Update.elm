module Update (..) where

import Task exposing (Task)
import Task.Extra exposing (delay)
import Time exposing (second)
import Effects exposing (Effects, Never, none, map, task)
import Result
import Response exposing (..)
import TransitRouter exposing (getRoute)
import Model exposing (..)
import Page.Home.Update as Home
import Page.Register.Update as Register
import Page.Login.Update as Login
import Page.Explore.Update as Explore
import Page.EditTrack.Update as EditTrack
import Page.Game.Update as Game
import Page.ListDrafts.Update as ListDrafts
import Page.Forum.Update as Forum
import Page.Admin.Update as Admin
import ServerApi
import Route exposing (..)
import Update.Utils as Utils


routerConfig : TransitRouter.Config Route Action Model
routerConfig =
  { mountRoute = mountRoute
  , getDurations = (\_ _ _ -> ( 50, 150 ))
  , actionWrapper = RouterAction
  , routeDecoder = Route.fromPath
  }


init : AppSetup -> Response Model Action
init setup =
  let
    ( model, routerEffects ) =
      TransitRouter.init routerConfig setup.path (initialModel setup)

    effects =
      Effects.batch
        [ routerEffects
        , task refreshLiveStatus
        ]
  in
    ( model, effects )


update : Action -> Model -> Response Model Action
update action ({ pages } as model) =
  case action of
    RouterAction routerAction ->
      TransitRouter.update routerConfig routerAction model

    SetPlayer p ->
      res { model | player = p } (Utils.redirect Home)
        |> mapEffects (\_ -> NoOp)

    SetLiveStatus result ->
      let
        liveStatus =
          Result.withDefault model.liveStatus result
      in
        taskRes
          { model | liveStatus = liveStatus }
          (delay (5 * second) refreshLiveStatus)

    UpdateDims dims ->
      res { model | dims = dims } none

    MouseEvent mouseEvent ->
      let
        handlerMaybe =
          case (getRoute model) of
            EditTrack _ ->
              Just (EditTrackAction << EditTrack.mouseAction)

            _ ->
              Nothing
      in
        case handlerMaybe of
          Just handler ->
            pageUpdate (handler mouseEvent) model

          _ ->
            res model none

    Logout ->
      taskRes model logoutTask

    PageAction pageAction ->
      pageUpdate pageAction model

    NoOp ->
      res model none


mountRoute : Route -> Route -> Model -> Response Model Action
mountRoute prevRoute newRoute ({ pages, player } as prevModel) =
  let
    routeTransition =
      Route.detectTransition prevRoute newRoute

    model =
      { prevModel | routeTransition = routeTransition }
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

      ListDrafts ->
        applyListDrafts (ListDrafts.mount pages.listDrafts) model

      Forum forumRoute ->
        applyForum (Forum.mount forumRoute) model

      Admin adminRoute ->
        applyAdmin Admin.mount model

      _ ->
        res model none


pageUpdate : PageAction -> Model -> Response Model Action
pageUpdate pageAction ({ pages, player, dims } as model) =
  case pageAction of
    HomeAction a ->
      applyHome (Home.update a pages.home) model

    LoginAction a ->
      applyLogin (Login.update a pages.login) model

    RegisterAction a ->
      applyRegister (Register.update a pages.register) model

    ExploreAction a ->
      applyExplore (Explore.update a pages.explore) model

    EditTrackAction a ->
      applyEditTrack (EditTrack.update dims a pages.editTrack) model

    GameAction a ->
      applyGame (Game.update player a pages.game) model

    ListDraftsAction a ->
      applyListDrafts (ListDrafts.update a pages.listDrafts) model

    ForumAction a ->
      applyForum (Forum.update a pages.forum) model

    AdminAction a ->
      applyAdmin (Admin.update a pages.admin) model


logoutTask : Task Effects.Never Action
logoutTask =
  ServerApi.postLogout
    |> Task.map (\r -> Result.map SetPlayer r |> Result.withDefault NoOp)


applyHome =
  applyPage (\s pages -> { pages | home = s }) HomeAction


applyLogin =
  applyPage (\s pages -> { pages | login = s }) LoginAction


applyRegister =
  applyPage (\s pages -> { pages | register = s }) RegisterAction


applyExplore =
  applyPage (\s pages -> { pages | explore = s }) ExploreAction


applyEditTrack =
  applyPage (\s pages -> { pages | editTrack = s }) EditTrackAction


applyGame =
  applyPage (\s pages -> { pages | game = s }) GameAction


applyListDrafts =
  applyPage (\s pages -> { pages | listDrafts = s }) ListDraftsAction


applyForum =
  applyPage (\s pages -> { pages | forum = s }) ForumAction


applyAdmin =
  applyPage (\s pages -> { pages | admin = s }) AdminAction


applyPage : (model -> Pages -> Pages) -> (action -> PageAction) -> Response model action -> Model -> Response Model Action
applyPage pagesUpdater actionWrapper response model =
  response
    |> mapModel (\p -> { model | pages = pagesUpdater p model.pages })
    |> mapEffects (actionWrapper >> PageAction)


refreshLiveStatus : Task Never Action
refreshLiveStatus =
  ServerApi.getLiveStatus
    |> Task.map SetLiveStatus
