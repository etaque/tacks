module Update where

import Task exposing (Task)
import Effects exposing (Effects, map, none, task)
import Result
import Response exposing (..)
import TransitRouter exposing (getRoute)

import Model exposing (..)

import Page.Home.Update as Home
import Page.Register.Update as Register
import Page.Login.Update as Login
import Page.ShowTrack.Update as ShowTrack
import Page.EditTrack.Update as EditTrack
import Page.ShowProfile.Update as ShowProfile
import Page.Game.Update as Game
import Page.ListDrafts.Update as ListDrafts
import Page.Forum.Update as Forum
import Page.Admin.Update as Admin

import ServerApi
import Route exposing (..)
import Update.Utils as Utils


routerConfig : TransitRouter.Config Route AppAction AppState
routerConfig =
  { mountRoute = mountRoute
  , getDurations = (\_ _ _ -> (50, 200))
  , actionWrapper = RouterAction
  , routeDecoder = Route.fromPath
  }


init : AppSetup -> AppResponse
init setup =
  TransitRouter.init routerConfig setup.path (initialAppState setup)


update : AppAction -> AppState -> AppResponse
update appAction ({pages} as appState) =
  case appAction of

    RouterAction routerAction ->
      TransitRouter.update routerConfig routerAction appState

    SetPlayer p ->
      res { appState | player = p } (Utils.redirect Home)
        |> mapEffects (\_ -> AppNoOp)

    UpdateDims dims ->
      res {appState | dims = dims } none

    MouseEvent mouseEvent ->
      let
        handlerMaybe = case (getRoute appState) of
          EditTrack _ -> Just (EditTrackAction << EditTrack.mouseAction)
          ShowTrack _ -> Just (ShowTrackAction << ShowTrack.mouseAction)
          _ -> Nothing
      in
        case handlerMaybe of
          Just handler ->
            updateModel (handler mouseEvent) appState
          _ ->
            res appState none

    Logout ->
      taskRes appState logoutTask

    PageAction modelAction ->
      updateModel modelAction appState

    AppNoOp ->
      res appState none


mountRoute : Route -> Route -> AppState -> AppResponse
mountRoute prevRoute newRoute ({pages, player} as prevAppState) =
  let
    routeTransition = Route.detectTransition prevRoute newRoute
    appState = { prevAppState | routeTransition = routeTransition }
  in
    case newRoute of

      Home ->
        applyHome (Home.mount player) appState

      Login ->
        applyLogin Login.mount appState

      Register ->
        applyRegister Register.mount appState

      ShowProfile ->
        applyShowProfile (ShowProfile.mount player) appState

      ShowTrack id ->
        applyShowTrack (ShowTrack.mount id) appState

      EditTrack id ->
        applyEditTrack (EditTrack.mount id) appState

      PlayTrack id ->
        applyGame (Game.mount id) appState

      ListDrafts ->
        applyListDrafts ListDrafts.mount appState

      Forum forumRoute ->
        applyForum Forum.mount appState

      Admin adminRoute ->
        applyAdmin Admin.mount appState

      EmptyRoute ->
        res appState none

      NotFound ->
        res appState none


updateModel : PageAction -> AppState -> (AppState, Effects AppAction)
updateModel modelAction ({pages, player, dims} as appState) =
  case modelAction of

    HomeAction a ->
      applyHome (Home.update a pages.home) appState

    LoginAction a ->
      applyLogin (Login.update a pages.login) appState

    RegisterAction a ->
      applyRegister (Register.update a pages.register) appState

    ShowTrackAction a ->
      applyShowTrack (ShowTrack.update a pages.showTrack) appState

    EditTrackAction a ->
      applyEditTrack (EditTrack.update dims a pages.editTrack) appState

    ShowProfileAction a ->
      applyShowProfile (ShowProfile.update a pages.showProfile) appState

    GameAction a ->
      applyGame (Game.update player a pages.game) appState

    ListDraftsAction a ->
      applyListDrafts (ListDrafts.update a pages.listDrafts) appState

    ForumAction a ->
      applyForum (Forum.update a pages.forum) appState

    AdminAction a ->
      applyAdmin (Admin.update a pages.admin) appState


logoutTask : Task Effects.Never AppAction
logoutTask =
  ServerApi.postLogout
    |> Task.map (\r -> Result.map SetPlayer r |> Result.withDefault AppNoOp)


applyHome = applyModel (\s pages -> { pages | home = s }) HomeAction
applyLogin = applyModel (\s pages -> { pages | login = s }) LoginAction
applyRegister = applyModel (\s pages -> { pages | register = s }) RegisterAction
applyShowProfile = applyModel (\s pages -> { pages | showProfile = s }) ShowProfileAction
applyShowTrack = applyModel (\s pages -> { pages | showTrack = s }) ShowTrackAction
applyEditTrack = applyModel (\s pages -> { pages | editTrack = s }) EditTrackAction
applyGame = applyModel (\s pages -> { pages | game = s }) GameAction
applyListDrafts = applyModel (\s pages -> { pages | listDrafts = s }) ListDraftsAction
applyForum = applyModel (\s pages -> { pages | forum = s }) ForumAction
applyAdmin = applyModel (\s pages -> { pages | admin = s }) AdminAction

applyModel : (model -> Pages -> Pages) -> (a -> PageAction) -> Response model a -> AppState -> AppResponse
applyModel pagesUpdater actionWrapper response appState =
  response
    |> mapModel (\model -> { appState | pages = pagesUpdater model appState.pages })
    |> mapEffects (actionWrapper >> PageAction)
