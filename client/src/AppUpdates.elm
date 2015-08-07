module AppUpdates where

import Task exposing (Task, andThen)
import Http

import Models exposing (..)
import AppTypes exposing (..)

import Screens.Home.HomeUpdates as Home
import Screens.Register.RegisterUpdates as Register
import Screens.Login.LoginUpdates as Login
import Screens.ShowTrack.ShowTrackUpdates as ShowTrack

import ServerApi
import Routes exposing (route)


screenActions : Signal AppAction
screenActions =
  Signal.mergeMany
    [ .signal Home.actions |> Signal.map HomeAction
    , .signal Register.actions |> Signal.map RegisterAction
    , .signal Login.actions |> Signal.map LoginAction
    , .signal ShowTrack.actions |> Signal.map ShowTrackAction
    ]


actionsMailbox : Signal.Mailbox AppAction
actionsMailbox =
  Signal.mailbox NoOp


update : AppAction -> AppUpdate -> AppUpdate
update action {appState} =
  case (action, appState.screen) of

    (SetPlayer p, _) ->
      AppUpdate { appState | player <- p } (Just (Routes.changePath "/")) Nothing

    (SetPath path, _) ->
      route appState path

    (HomeAction a, HomeScreen screen) ->
      Home.update a screen
        |> screenToAppUpdate appState HomeScreen

    (LoginAction a, LoginScreen screen) ->
      Login.update a screen
        |> screenToAppUpdate appState LoginScreen

    (RegisterAction a, RegisterScreen screen) ->
      Register.update a screen
        |> screenToAppUpdate appState RegisterScreen

    (ShowTrackAction a, ShowTrackScreen screen) ->
      ShowTrack.update a screen
        |> screenToAppUpdate appState ShowTrackScreen

    (Logout, _) ->
      AppUpdate appState (Just logoutTask) Nothing

    _ ->
      noUpdate appState


noUpdate : AppState -> AppUpdate
noUpdate appState = AppUpdate appState Nothing Nothing

logoutTask : Task Http.Error ()
logoutTask =
  ServerApi.postLogout `andThen`
    (\p -> Signal.send actionsMailbox.address (SetPlayer p))
