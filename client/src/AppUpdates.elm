module AppUpdates where

import Task exposing (Task, andThen)
import Task.Extra exposing (delay)
import History
import RouteParser
import Effects exposing (Effects, map, none, task)
import Result

import AppTypes exposing (..)

import Screens.Home.Updates as Home
import Screens.Register.Updates as Register
import Screens.Login.Updates as Login
import Screens.ShowTrack.Updates as ShowTrack
import Screens.EditTrack.Updates as EditTrack
import Screens.ShowProfile.Updates as ShowProfile
import Screens.Game.Updates as Game
import Screens.ListDrafts.Updates as ListDrafts

import ServerApi
import Routes exposing (..)
import Screens.UpdateUtils as Utils


initialAppUpdate : AppSetup -> (AppState, Effects AppAction)
initialAppUpdate setup =
  let
    appState = initialAppState setup
    task = Task.succeed (SetPath setup.path)
  in
    appState &! task


update : AppAction -> AppState -> (AppState, Effects AppAction)
update appAction ({screens, ctx} as appState) =
  case appAction of

    SetPath path ->
      appState &! (History.setPath path |> Task.map (\_ -> AppNoOp))

    PathChanged path ->
      let
        newCtx = { ctx | transitStatus = Exit }
        newAppState = { appState | path = path, ctx = newCtx }
        newRoute = RouteParser.match routeParsers path
        fx = MountRoute newRoute
          |> Task.succeed
          |> delay 100
          |> Effects.task
      in
        newAppState &: fx

    MountRoute maybeRoute ->
      let
        newCtx = { ctx | transitStatus = Enter }
        newAppState = { appState | route = maybeRoute, ctx = newCtx }
      in
        case newAppState.route of
          Just route ->
            mountRoute newAppState route
          Nothing -> -- TODO 404
            newAppState &: none

    SetPlayer p ->
      let
        newCtx = { ctx | player = p }
        fx = map (\_ -> AppNoOp) (Utils.redirect Routes.Home)
      in
        { appState | ctx = newCtx } &: fx

    UpdateDims dims ->
      {appState | ctx = { ctx | dims = dims } } &: none

    Logout ->
      appState &! logoutTask

    ScreenAction screenAction ->
      updateScreen screenAction appState

    AppNoOp ->
      appState &: none


mountRoute : AppState -> Routes.Route -> (AppState, Effects AppAction)
mountRoute ({ctx} as appState) route =
  case route of

    Home ->
      applyHome (Home.mount ctx.player) appState

    Login ->
      applyLogin Login.mount appState

    Register ->
      applyRegister Register.mount appState

    ShowProfile ->
      applyShowProfile (ShowProfile.mount ctx.player) appState

    ShowTrack id ->
      applyShowTrack (ShowTrack.mount id) appState

    EditTrack id ->
      applyEditTrack (EditTrack.mount id) appState

    PlayTrack id ->
      applyGame (Game.mount id) appState

    ListDrafts ->
      applyListDrafts ListDrafts.mount appState


updateScreen : ScreenAction -> AppState -> (AppState, Effects AppAction)
updateScreen screenAction ({screens, ctx} as appState) =
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
      applyEditTrack (EditTrack.update ctx.dims a screens.editTrack) appState

    ShowProfileAction a ->
      applyShowProfile (ShowProfile.update a screens.showProfile) appState

    GameAction a ->
      applyGame (Game.update ctx.player a screens.game) appState

    ListDraftsAction a ->
      applyListDrafts (ListDrafts.update a screens.listDrafts) appState


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

applyScreen : (screen -> Screens -> Screens) -> (a -> ScreenAction) -> (screen, Effects a) -> AppState -> (AppState, Effects AppAction)
applyScreen screensUpdater toScreenAction (screen, effect) appState =
  let
    newState = { appState | screens = screensUpdater screen appState.screens }
    newEffect = map (toScreenAction >> ScreenAction) effect
  in
    newState &: newEffect

