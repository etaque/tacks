module AppUpdates where

import Task exposing (Task, andThen)
import Signal exposing (send)
import History
import RouteParser

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


update : AppInput -> AppUpdate -> AppUpdate
update {action, clock} {appState} =
  case action of

    SetPath path ->
      AppUpdate appState
        (Just <| History.setPath path)


    PathChanged path ->
     RouteParser.match routeParsers path
        |> Maybe.map (mountRoute appState)
        |> Maybe.withDefault (mountNotFound appState path)

    SetPlayer p ->
      let
        newPath = Routes.toPath Routes.Home
        reaction = Signal.send appActionsMailbox.address (SetPath newPath)
      in
        AppUpdate { appState | player = p } (Just reaction)

    UpdateDims dims ->
      let
        newScreen = updateScreenDims dims appState.screen
      in
        AppUpdate { appState | dims = dims, screen = newScreen } Nothing

    Logout ->
      AppUpdate appState (Just logoutTask)

    ScreenAction screenAction ->
      updateScreen clock screenAction appState

    AppNoOp ->
      noUpdate appState


mountRoute : AppState -> Routes.Route -> AppUpdate
mountRoute ({player, dims} as appState) route =
  let
    mount = toAppUpdate appState
  in
    case route of
      Home ->
        mount HomeScreen (Home.mount player)
      Login ->
        mount LoginScreen Login.mount
      Register ->
        mount RegisterScreen Register.mount
      ShowProfile ->
        mount ShowProfileScreen (ShowProfile.mount player)
      ShowTrack id ->
        mount ShowTrackScreen (ShowTrack.mount id)
      EditTrack id ->
        mount EditTrackScreen (EditTrack.mount dims id)
      PlayTrack id ->
        mount GameScreen (Game.mount id)


mountNotFound : AppState -> String -> AppUpdate
mountNotFound appState path =
  AppUpdate { appState | screen = NotFoundScreen path } Nothing


updateScreen : Clock -> ScreenAction -> AppState -> AppUpdate
updateScreen clock screenAction ({screen} as appState) =
  case screenAction of

    HomeAction a ->
      case screen of
        HomeScreen s ->
          Home.update a s |> toAppUpdate appState HomeScreen
        _ ->
          noUpdate appState

    LoginAction a ->
      case screen of
        LoginScreen s ->
          Login.update a s |> toAppUpdate appState LoginScreen
        _ ->
          noUpdate appState

    RegisterAction a ->
      case screen of
        RegisterScreen s ->
          Register.update a s |> toAppUpdate appState RegisterScreen
        _ ->
          noUpdate appState

    ShowTrackAction a ->
      case screen of
        ShowTrackScreen s ->
          ShowTrack.update a s |> toAppUpdate appState ShowTrackScreen
        _ ->
          noUpdate appState

    EditTrackAction a ->
      case screen of
        EditTrackScreen s ->
          EditTrack.update a s |> toAppUpdate appState EditTrackScreen
        _ ->
          noUpdate appState

    ShowProfileAction a ->
      case screen of
        ShowProfileScreen s ->
          ShowProfile.update a s |> toAppUpdate appState ShowProfileScreen
        _ ->
          noUpdate appState

    GameAction a ->
      case screen of
        GameScreen s ->
          Game.update appState.player clock a s |> toAppUpdate appState GameScreen
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
noUpdate appState =
  AppUpdate appState Nothing


toAppUpdate : AppState -> (screen -> AppScreen) -> ScreenUpdate screen -> AppUpdate
toAppUpdate appState toAppScreen {screen, reaction} =
  AppUpdate
    { appState | screen = toAppScreen screen }
    reaction


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
