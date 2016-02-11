module AppUpdates where

import Task exposing (Task)
import Effects exposing (Effects, map, none, task)
import Result
import Response exposing (..)
import TransitRouter exposing (getRoute)

import AppTypes exposing (..)

import Screens.Home.Update as Home
import Screens.Register.Update as Register
import Screens.Login.Update as Login
import Screens.ShowTrack.Update as ShowTrack
import Screens.EditTrack.Update as EditTrack
import Screens.ShowProfile.Update as ShowProfile
import Screens.Game.Update as Game
import Screens.ListDrafts.Update as ListDrafts
import Screens.Admin.Update as Admin

import ServerApi
import Routes exposing (..)
import Screens.UpdateUtils as Utils


routerConfig : TransitRouter.Config Route AppAction AppState
routerConfig =
  { mountRoute = mountRoute
  , getDurations = (\_ _ _ -> (50, 200))
  , actionWrapper = RouterAction
  , routeDecoder = Routes.fromPath
  }


init : AppSetup -> AppResponse
init setup =
  TransitRouter.init routerConfig setup.path (initialAppState setup)


update : AppAction -> AppState -> AppResponse
update appAction ({screens} as appState) =
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
            updateScreen (handler mouseEvent) appState
          _ ->
            res appState none

    Logout ->
      taskRes appState logoutTask

    ScreenAction screenAction ->
      updateScreen screenAction appState

    AppNoOp ->
      res appState none


mountRoute : Route -> Route -> AppState -> AppResponse
mountRoute prevRoute newRoute ({screens, player} as prevAppState) =
  let
    routeTransition = Routes.detectTransition prevRoute newRoute
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

      Admin adminRoute ->
        applyAdmin Admin.mount appState

      EmptyRoute ->
        res appState none

      NotFound ->
        res appState none


updateScreen : ScreenAction -> AppState -> (AppState, Effects AppAction)
updateScreen screenAction ({screens, player, dims} as appState) =
  case screenAction of

    HomeAction a ->
      applyHome (Home.update a screens.home) appState

    LoginAction a ->
      applyLogin (Login.update a screens.login) appState

    RegisterAction a ->
      applyRegister (Register.update a screens.register) appState

    ShowTrackAction a ->
      applyShowTrack (ShowTrack.update a screens.showTrack) appState

    EditTrackAction a ->
      applyEditTrack (EditTrack.update dims a screens.editTrack) appState

    ShowProfileAction a ->
      applyShowProfile (ShowProfile.update a screens.showProfile) appState

    GameAction a ->
      applyGame (Game.update player a screens.game) appState

    ListDraftsAction a ->
      applyListDrafts (ListDrafts.update a screens.listDrafts) appState

    AdminAction a ->
      applyAdmin (Admin.update a screens.admin) appState


logoutTask : Task Effects.Never AppAction
logoutTask =
  ServerApi.postLogout
    |> Task.map (\r -> Result.map SetPlayer r |> Result.withDefault AppNoOp)


applyHome = applyScreen (\s screens -> { screens | home = s }) HomeAction
applyLogin = applyScreen (\s screens -> { screens | login = s }) LoginAction
applyRegister = applyScreen (\s screens -> { screens | register = s }) RegisterAction
applyShowProfile = applyScreen (\s screens -> { screens | showProfile = s }) ShowProfileAction
applyShowTrack = applyScreen (\s screens -> { screens | showTrack = s }) ShowTrackAction
applyEditTrack = applyScreen (\s screens -> { screens | editTrack = s }) EditTrackAction
applyGame = applyScreen (\s screens -> { screens | game = s }) GameAction
applyListDrafts = applyScreen (\s screens -> { screens | listDrafts = s }) ListDraftsAction
applyAdmin = applyScreen (\s screens -> { screens | admin = s }) AdminAction

applyScreen : (screen -> Screens -> Screens) -> (a -> ScreenAction) -> Response screen a -> AppState -> AppResponse
applyScreen screensUpdater actionWrapper response appState =
  response
    |> mapModel (\screen -> { appState | screens = screensUpdater screen appState.screens })
    |> mapEffects (actionWrapper >> ScreenAction)
