module AppUpdates where

import Task exposing (Task, andThen)
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
update appAction appState =
  case appAction of

    SetPath path ->
      appState &! (History.setPath path |> Task.map (\_ -> AppNoOp))

    PathChanged path ->
      let
        newAppState = { appState | route = RouteParser.match routeParsers path }
      in
        case newAppState.route of
          Just route ->
            mountRoute newAppState route
          Nothing -> -- TODO 404
            newAppState &: none

    SetPlayer p ->
      { appState | player = p } &: (map (\_ -> AppNoOp) (Utils.redirect Routes.Home))

    UpdateDims dims ->
      updateScreenDims dims appState &: none

    Logout ->
      appState &! logoutTask

    ScreenAction screenAction ->
      updateScreen screenAction appState

    AppNoOp ->
      appState &: none


mountRoute : AppState -> Routes.Route -> (AppState, Effects AppAction)
mountRoute ({player, dims} as appState) route =
  case route of
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
      applyEditTrack (EditTrack.mount dims id) appState
    PlayTrack id ->
      applyGame (Game.mount id) appState


updateScreen : ScreenAction -> AppState -> (AppState, Effects AppAction)
updateScreen screenAction ({screens} as appState) =
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
      applyEditTrack (EditTrack.update a screens.editTrack) appState

    ShowProfileAction a ->
      applyShowProfile (ShowProfile.update a screens.showProfile) appState

    GameAction a ->
      applyGame (Game.update appState.player a screens.game) appState


updateScreenDims : (Int, Int) -> AppState -> AppState
updateScreenDims dims ({route, screens} as appState) =
  case route of
    Just (EditTrack _) ->
      let
        newScreens = { screens | editTrack = EditTrack.updateDims dims screens.editTrack }
      in
        { appState | screens = newScreens, dims = dims }
    _ ->
      appState


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

applyScreen : (screen -> Screens -> Screens) -> (a -> ScreenAction) -> (screen, Effects a) -> AppState -> (AppState, Effects AppAction)
applyScreen screensUpdater toScreenAction (screen, effect) appState =
  let
    newState = { appState | screens = screensUpdater screen appState.screens }
    newEffect = map (toScreenAction >> ScreenAction) effect
  in
    newState &: newEffect

