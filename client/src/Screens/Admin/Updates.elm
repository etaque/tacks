module Screens.Admin.Updates where

import Task exposing (Task, succeed, andThen)
import Signal
import Effects exposing (Effects, Never, none, map)
import Response exposing (..)

import AppTypes exposing (..)
import Models exposing (..)
import Screens.Admin.Types as Types exposing (..)
import ServerApi
import Screens.UpdateUtils as Utils


addr : Signal.Address Action
addr =
  Utils.screenAddr AdminAction


mount : (Screen, Effects Action)
mount =
  taskRes initial refreshData


update : Action -> Screen -> (Screen, Effects Action)
update action screen =
  case action of

    RefreshData ->
      taskRes screen refreshData

    RefreshDataResult result ->
      let
        {tracks, users} = Result.withDefault (AdminData [] []) result
      in
        res { screen | tracks = tracks, users = users } none

    DeleteTrack id ->
      taskRes screen (Task.map DeleteTrackResult (ServerApi.deleteDraft id))

    DeleteTrackResult result ->
      case result of
        Ok id ->
          res { screen | tracks = List.filter (\t -> t.id /= id) screen.tracks } none
        Err _ ->
          res screen none

    NoOp ->
      res screen none


-- startTransition : Route -> Route -> Effects Action
-- startTransition prevRoute newRoute =
--   let
--     noTrans = effect (UpdateRoute newRoute)
--   in
--     case (prevRoute, newRoute) of
--       (ListTracks _, ListTracks _) -> noTrans
--       (ListUsers _, ListUsers _) -> noTrans
--       _ -> effect (StartTransition newRoute)


refreshData : Task Never Action
refreshData =
  ServerApi.loadAdminData
    |> Task.map RefreshDataResult

