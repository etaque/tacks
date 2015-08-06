module AppUpdates where

import Task exposing (Task)
import Http

import Models exposing (..)
import AppTypes exposing (..)

import Screens.Home.HomeUpdates as Home
import Screens.Register.RegisterUpdates as Register
import Screens.Login.LoginUpdates as Login


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
  case action of

    SetPlayer p ->
      basic { appState | player <- p }

    SetPath path ->
      -- TODO routes
      basic appState

    HomeAction a ->
      case appState.screen of
        HomeScreen screen ->
          Home.update a screen
            |> toScreenUpdate appState HomeScreen HomeAction
        _ ->
          basic appState

    LoginAction a ->
      case appState.screen of
        LoginScreen screen ->
          Login.update a screen
            |> toScreenUpdate appState LoginScreen LoginAction
        _ ->
          basic appState

    RegisterAction a ->
      case appState.screen of
        RegisterScreen screen ->
          Register.update a screen
            |> toScreenUpdate appState RegisterScreen RegisterAction
        _ ->
          basic appState

    NoOp ->
      basic appState


basic : AppState -> AppUpdate
basic appState = AppUpdate appState Nothing Nothing


toScreenUpdate : AppState -> (screen -> AppScreen) -> (screenAction -> AppAction) -> ScreenUpdate screen screenAction -> AppUpdate
toScreenUpdate appState toAppScreen toAppAction {screen, reaction, request} =
  AppUpdate
    { appState | screen <- toAppScreen screen }
    (Maybe.map (Task.map toAppAction) reaction)
    request


initialAppUpdate : Player -> AppUpdate
initialAppUpdate player =
  AppUpdate
    (initialAppState player)
    Nothing
    Nothing


initialAppState : Player -> AppState
initialAppState player =
  { player = player
  , screen = NoScreen
  }
