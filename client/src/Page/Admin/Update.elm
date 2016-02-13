module Page.Admin.Update where

import Task exposing (Task, succeed, andThen)
import Signal
import Effects exposing (Effects, Never, none, map)
import Response exposing (..)

import Model exposing (..)
import Model.Shared exposing (..)
import Page.Admin.Model as Types exposing (..)
import ServerApi
import Update.Utils as Utils


addr : Signal.Address Action
addr =
  Utils.pageAddr AdminAction


mount : (Model, Effects Action)
mount =
  taskRes initial refreshData


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of

    RefreshData ->
      taskRes model refreshData

    RefreshDataResult result ->
      let
        {tracks, users} = Result.withDefault (AdminData [] []) result
      in
        res { model | tracks = tracks, users = users } none

    DeleteTrack id ->
      taskRes model (Task.map DeleteTrackResult (ServerApi.deleteDraft id))

    DeleteTrackResult result ->
      case result of
        Ok id ->
          res { model | tracks = List.filter (\t -> t.id /= id) model.tracks } none
        Err _ ->
          res model none

    NoOp ->
      res model none


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

