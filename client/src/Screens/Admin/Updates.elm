module Screens.Admin.Updates where

import Task exposing (Task, succeed, andThen)
import Task.Extra exposing (delay)
import Time exposing (second)
import Signal
import Effects exposing (Effects, Never, none, map)

import AppTypes exposing (..)
import Models exposing (..)
import Screens.Admin.Types exposing (..)
import ServerApi
import Routes
import Screens.UpdateUtils as Utils


addr : Signal.Address Action
addr =
  Utils.screenAddr AdminAction


mount : Routes.AdminRoute -> (Screen, Effects Action)
mount route =
  initial route &! refreshData


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
      screen &: none -- TODO

    NoOp ->
      screen &: none


refreshData : Task Never Action
refreshData =
  ServerApi.loadAdminData
    |> Task.map RefreshDataResult

