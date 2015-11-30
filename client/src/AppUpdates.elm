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
  case (action, appState.screen) of

    -- (SetPlayer p, _) ->
    --   AppUpdate { appState | player = p } (Just (Routes.changePath "/")) Nothing

    -- (SetPath path, _) ->
    --   route appState path

    (UpdateDims dims, _) ->
      let
        newScreen = updateScreenDims dims appState.screen
      in
        AppUpdate { appState | dims = dims, screen = newScreen } Nothing Nothing

    (HomeAction a, HomeScreen screen) ->
      Home.update a screen
        |> mapAppUpdate appState HomeScreen

    (LoginAction a, LoginScreen screen) ->
      Login.update a screen
        |> mapAppUpdate appState LoginScreen

    (RegisterAction a, RegisterScreen screen) ->
      Register.update a screen
        |> mapAppUpdate appState RegisterScreen

    (ShowTrackAction a, ShowTrackScreen screen) ->
      ShowTrack.update a screen
        |> mapAppUpdate appState ShowTrackScreen

    (EditTrackAction a, EditTrackScreen screen) ->
      EditTrack.update a screen
        |> mapAppUpdate appState EditTrackScreen

    (ShowProfileAction a, ShowProfileScreen screen) ->
      ShowProfile.update a screen
        |> mapAppUpdate appState ShowProfileScreen

    (GameAction a, GameScreen screen) ->
      Game.update appState.player clock a screen
        |> mapAppUpdate appState GameScreen

    (Logout, _) ->
      AppUpdate appState (Just logoutTask) Nothing

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
