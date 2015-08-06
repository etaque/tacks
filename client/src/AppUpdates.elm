module AppUpdates where

import Task exposing (Task)
import Http

import Models exposing (..)
import AppTypes exposing (..)

import Screens.Home.HomeUpdates as Home
import Screens.Register.RegisterUpdates as Register
import Screens.Login.LoginUpdates as Login

import Routes exposing (route)


screenActions : Signal AppAction
screenActions =
  Signal.mergeMany
    [ .signal Home.actions |> Signal.map HomeAction
    , .signal Register.actions |> Signal.map RegisterAction
    , .signal Login.actions |> Signal.map LoginAction
    ]


actionsMailbox : Signal.Mailbox AppAction
actionsMailbox =
  Signal.mailbox NoOp


update : AppAction -> AppUpdate -> AppUpdate
update action {appState} =
  case (action, appState.screen) of

    (SetPlayer p, _) ->
      noUpdate { appState | player <- p }

    (SetPath path, _) ->
      route appState path

    (HomeAction a, HomeScreen screen) ->
      Home.update a screen
        |> screenToAppUpdate appState HomeScreen HomeAction

    (LoginAction a, LoginScreen screen) ->
      Login.update a screen
        |> screenToAppUpdate appState LoginScreen LoginAction

    (RegisterAction a, RegisterScreen screen) ->
      Register.update a screen
        |> screenToAppUpdate appState RegisterScreen RegisterAction

    _ ->
      noUpdate appState


noUpdate : AppState -> AppUpdate
noUpdate appState = AppUpdate appState Nothing Nothing

