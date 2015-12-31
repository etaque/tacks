module AppUpdates where

import Task exposing (Task)
import History
import Effects exposing (Effects, map, none, task)
import Result

import Constants exposing (..)
import AppTypes exposing (..)

import Screens.Home.Updates as Home
import Screens.Register.Updates as Register
import Screens.Login.Updates as Login
import Screens.ShowTrack.Updates as ShowTrack
import Screens.EditTrack.Updates as EditTrack
import Screens.ShowProfile.Updates as ShowProfile
import Screens.Game.Updates as Game
import Screens.ListDrafts.Updates as ListDrafts
import Screens.Admin.Updates as Admin

import ServerApi
import Routes exposing (..)
import Screens.UpdateUtils as Utils

import Transition


init : AppSetup -> AppResponse
init setup =
  let
    appState = initialAppState setup
    fx = SetPath setup.path |> Task.succeed |> task
  in
    res appState fx


update : AppAction -> AppState -> AppResponse
update appAction ({screens, ctx} as appState) =
  case appAction of

    SetPath path ->
      taskRes appState (History.setPath path |> Task.map (\_ -> AppNoOp))

    PathChanged path ->
      let
        newRoute = Routes.fromPath path
      in
        Transition.init newRoute appState

    MountRoute route ->
      let
        newAppState = { appState | route = route }
      in
        case route of
          Just r ->
            mountRoute appState.route newAppState r
          Nothing ->
            -- TODO 404
            staticRes newAppState

    TransitAction a ->
      Transition.update a appState

    SetPlayer p ->
      let
        newCtx = { ctx | player = p }
        fx = map (\_ -> AppNoOp) (Utils.redirect Routes.Home)
      in
        res { appState | ctx = newCtx } fx

    UpdateDims dims ->
      staticRes {appState | ctx = { ctx | dims = dims } }

    MouseEvent mouseEvent ->
      let
        handlerMaybe = case appState.route of
          Just (EditTrack _) -> Just (EditTrackAction << EditTrack.mouseAction)
          Just (ShowTrack _) -> Just (ShowTrackAction << ShowTrack.mouseAction)
          _ -> Nothing
      in
        case handlerMaybe of
          Just handler ->
            updateScreen (handler mouseEvent) appState
          _ ->
            staticRes appState

    Logout ->
      taskRes appState logoutTask

    ScreenAction screenAction ->
      updateScreen screenAction appState

    AppNoOp ->
      staticRes appState


mountRoute : Maybe Routes.Route -> AppState -> Routes.Route -> (AppState, Effects AppAction)
mountRoute prevRoute ({ctx, screens} as appState) newRoute =
  case newRoute of

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

    Admin adminRoute ->
      case prevRoute of
        -- Just (Routes.Admin _) ->
        --   applyAdmin (Admin.updateRoute adminRoute screens.admin) appState
        _ ->
          applyAdmin Admin.mount appState

      -- let
      --   result = case prevRoute of
      --     Just (Routes.Admin _) ->
      --       (screens.admin, Effects.none)
      --       -- (screens.admin, Admin.updateRouteEffect adminRoute)
      --     _ ->
      --       Admin.mount
      -- in
      --   applyAdmin result appState


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
    |> mapState (\screen -> { appState | screens = screensUpdater screen appState.screens })
    |> mapEffects (actionWrapper >> ScreenAction)
