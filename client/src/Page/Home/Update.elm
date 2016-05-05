module Page.Home.Update (..) where

import Task exposing (Task, succeed, andThen)
import Signal
import Effects exposing (Effects, Never, none, map, task)
import Response exposing (..)
import Model
import Model.Shared exposing (..)
import Page.Home.Model exposing (..)
import ServerApi
import Update.Utils as Utils


addr : Signal.Address Action
addr =
  Utils.pageAddr Model.HomeAction


mount : Player -> ( Model, Effects Action )
mount player =
  res (initial player) (task loadRaceReports)


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    SetRaceReports result ->
      let
        raceReports =
          Result.withDefault [] result
      in
        res { model | raceReports = raceReports } none

    SetHandle handle ->
      res { model | handle = handle } none

    SubmitHandle ->
      Task.map SubmitHandleResult (ServerApi.postHandle model.handle)
        |> taskRes model

    SubmitHandleResult result ->
      Result.map (Utils.setPlayer) result
        |> Result.withDefault none
        |> Utils.always NoOp
        |> res model

    FocusTrack maybeTrackId ->
      res { model | trackFocus = maybeTrackId } none

    NoOp ->
      res model none


loadRaceReports : Task Never Action
loadRaceReports =
  ServerApi.getRaceReports Nothing
    |> Task.map SetRaceReports
