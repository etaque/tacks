module Page.Home.Update (..) where

import Task exposing (Task, succeed, andThen)
import Signal
import Effects exposing (Effects, Never, none, map, task)
import Response exposing (..)
import Dialog
import Model
import Model.Shared exposing (..)
import Page.Home.Model exposing (..)
import ServerApi
import Update.Utils as Utils


addr : Signal.Address Action
addr =
  Utils.pageAddr Model.HomeAction


mount : Model -> ( Model, Effects Action )
mount model =
  res model (task loadRaceReports)


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    SetRaceReports result ->
      let
        raceReports =
          Result.withDefault [] result
      in
        res { model | raceReports = raceReports } none

    ShowDialog content ->
      Dialog.taggedOpen DialogAction { model | showDialog = content }

    DialogAction a ->
      Dialog.taggedUpdate DialogAction a model

    NoOp ->
      res model none


loadRaceReports : Task Never Action
loadRaceReports =
  ServerApi.getRaceReports Nothing
    |> Task.map SetRaceReports
