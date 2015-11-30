module AppUpdates where

import Task exposing (Task, andThen)

import AppTypes exposing (..)

import Screens.Home.Updates as Home
import Screens.Register.Updates as Register
import Screens.Login.Updates as Login
import Screens.ShowTrack.Updates as ShowTrack
import Screens.EditTrack.Updates as EditTrack
import Screens.ShowProfile.Updates as ShowProfile
import Screens.Game.Updates as Game

import ServerApi
-- import Routes exposing (route)


update : AppInput -> AppUpdate -> AppUpdate
update {action, clock} {appState} =
  case action of

    SetPlayer p ->
      noUpdate appState
    --   AppUpdate { appState | player = p } (Just (Routes.changePath "/")) Nothing

    SetPath path ->
      noUpdate appState
      -- route appState path

    UpdateDims dims ->
      let
        newScreen = updateScreenDims dims appState.screen
      in
        AppUpdate { appState | dims = dims, screen = newScreen } Nothing Nothing

    Logout ->
      AppUpdate appState (Just logoutTask) Nothing

    ScreenAction screenAction ->
      updateScreen clock screenAction appState

    AppNoOp ->
      noUpdate appState


updateScreen : Clock -> ScreenAction -> AppState -> AppUpdate
updateScreen clock screenAction ({screen} as appState) =
  case screenAction of

    HomeAction a ->
      case screen of
        HomeScreen s ->
          Home.update a s |> mapAppUpdate appState HomeScreen
        _ ->
          noUpdate appState

    LoginAction a ->
      case screen of
        LoginScreen s ->
          Login.update a s |> mapAppUpdate appState LoginScreen
        _ ->
          noUpdate appState

    RegisterAction a ->
      case screen of
        RegisterScreen s ->
          Register.update a s |> mapAppUpdate appState RegisterScreen
        _ ->
          noUpdate appState

    ShowTrackAction a ->
      case screen of
        ShowTrackScreen s ->
          ShowTrack.update a s |> mapAppUpdate appState ShowTrackScreen
        _ ->
          noUpdate appState

    EditTrackAction a ->
      case screen of
        EditTrackScreen s ->
          EditTrack.update a s |> mapAppUpdate appState EditTrackScreen
        _ ->
          noUpdate appState

    ShowProfileAction a ->
      case screen of
        ShowProfileScreen s ->
          ShowProfile.update a s |> mapAppUpdate appState ShowProfileScreen
        _ ->
          noUpdate appState

    GameAction a ->
      case screen of
        GameScreen s ->
          Game.update appState.player clock a s |> mapAppUpdate appState GameScreen
        _ ->
          noUpdate appState

updateScreenDims : (Int, Int) -> AppScreen -> AppScreen
updateScreenDims dims appScreen =
  case appScreen of
    EditTrackScreen screen ->
      EditTrackScreen (EditTrack.updateDims dims screen)
    _ ->
      appScreen

noUpdate : AppState -> AppUpdate
noUpdate appState = AppUpdate appState Nothing Nothing

logoutTask : Task Never ()
logoutTask =
  ServerApi.postLogout `andThen`
    \result ->
      case result of
        Ok p ->
          Signal.send appActionsMailbox.address (SetPlayer p)
        Err _ ->
          -- TODO handle error
          Task.succeed ()
