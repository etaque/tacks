module AppUpdates where

import Task exposing (Task, andThen)
import Http

import Models exposing (..)
import AppTypes exposing (..)

import Screens.Home.Updates as Home
import Screens.Register.Updates as Register
import Screens.Login.Updates as Login
import Screens.ShowTrack.Updates as ShowTrack
import Screens.Game.Updates as Game

import ServerApi
import Routes exposing (route)


screenActions : Signal AppAction
screenActions =
  Signal.mergeMany
    [ .signal Home.actions |> Signal.map HomeAction
    , .signal Register.actions |> Signal.map RegisterAction
    , .signal Login.actions |> Signal.map LoginAction
    , .signal ShowTrack.actions |> Signal.map ShowTrackAction
    , .signal Game.actions |> Signal.map GameAction
    ]


actionsMailbox : Signal.Mailbox AppAction
actionsMailbox =
  Signal.mailbox NoOp


update : AppInput -> AppUpdate -> AppUpdate
update {action, clock} {appState} =
  case (action, appState.screen) of

    (SetPlayer p, _) ->
      AppUpdate { appState | player <- p } (Just (Routes.changePath "/")) Nothing

    (SetPath path, _) ->
      route appState path

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

    (GameAction a, GameScreen screen) ->
      Game.update appState.player clock a screen
        |> mapAppUpdate appState GameScreen

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
