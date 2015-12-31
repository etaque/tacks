module Transition where

import Task exposing (Task)
import Effects exposing (Effects, map, none, task)
import Transit

import AppTypes exposing (..)
import Routes exposing (..)
import Screens.Admin.Routes as AdminRoutes
import Screens.Admin.Updates as Admin


type Transition
  = ForMain
  | ForAdmin AdminRoutes.Route AdminRoutes.Route
  | None


init : Maybe Route -> AppState -> AppResponse
init route appState =
  let
    transition = detect appState.route route
    mountAction = MountRoute route
  in
    case transition of
      ForMain ->
        initMain mountAction appState
      ForAdmin from to ->
        initAdmin from to { appState | route = route }
      None ->
        res appState (effect mountAction)


detect : Maybe Route -> Maybe Route -> Transition
detect prevRoute route =
  case (prevRoute, route) of
    (Just (Admin from), Just (Admin to)) ->
      ForAdmin from to
    _ ->
      if prevRoute /= route then
        ForMain
      else
        None


initMain : AppAction -> AppState -> AppResponse
initMain action state =
  let
    timeline = Transit.timeline 100 action 200
  in
    Transit.init TransitAction timeline state.ctx
      |> mapState (\ctx -> { state | ctx = ctx })


initAdmin : AdminRoutes.Route -> AdminRoutes.Route -> AppState -> AppResponse
initAdmin from to state =
  res state (Admin.startTransition from to)
    |> mapEffects (AdminAction >> ScreenAction)


update : Transit.Action AppAction -> AppState -> AppResponse
update action state =
  Transit.update TransitAction action state.ctx
    |> mapState (\ctx -> { state | ctx = ctx })

