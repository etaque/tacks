module Screens.Admin.Updates where

import Task exposing (Task, succeed, andThen)
import Signal
import Effects exposing (Effects, Never, none, map)

import Transit

import Constants exposing (transitionDuration)
import AppTypes exposing (..)
import Models exposing (..)
import Screens.Admin.Types as Types exposing (..)
import Screens.Admin.Routes exposing (..)
import ServerApi
import Screens.UpdateUtils as Utils


addr : Signal.Address Action
addr =
  Utils.screenAddr AdminAction


mount : (Screen, Effects Action)
mount =
  initial &! refreshData


update : Action -> Screen -> (Screen, Effects Action)
update action screen =
  case action of

    RefreshData ->
      screen &! refreshData

    RefreshDataResult result ->
      let
        {tracks, users} = result ?: (AdminData [] [])
      in
        { screen | tracks = tracks, users = users } &: none

    DeleteTrack id ->
      screen &! Task.map DeleteTrackResult (ServerApi.deleteDraft id)

    DeleteTrackResult result ->
      case result of
        Ok id ->
          { screen | tracks = List.filter (\t -> t.id /= id) screen.tracks } &: none
        Err _ ->
          screen &: none

    UpdateRoute route ->
      Transit.init transitionDuration { screen | route = route } Types.TransitionAction

    Types.TransitionAction a ->
      Transit.update a screen Types.TransitionAction

    NoOp ->
      screen &: none

updateRouteEffect : Route -> Effects Action
updateRouteEffect route =
  Task.succeed (UpdateRoute route) |> Effects.task


refreshData : Task Never Action
refreshData =
  ServerApi.loadAdminData
    |> Task.map RefreshDataResult

