module Page.Home.Update (..) where

import Task exposing (Task, succeed, andThen)
import Task.Extra exposing (delay)
import Time exposing (second)
import Signal
import Effects exposing (Effects, Never, none, map, task)
import Response exposing (..)
import Model
import Model.Shared exposing (..)
import Page.Home.Model exposing (..)
import ServerApi
import Route
import Update.Utils as Utils


addr : Signal.Address Action
addr =
  Utils.pageAddr Model.HomeAction


mount : Player -> ( Model, Effects Action )
mount player =
  let
    effects =
      Effects.batch
        [ task refreshLiveStatus
        , task loadRaceReports
        ]
  in
    res (initial player) effects


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    SetLiveStatus result ->
      let
        liveStatus =
          Result.withDefault model.liveStatus result
      in
        delay (5 * second) refreshLiveStatus
          |> taskRes { model | liveStatus = liveStatus }

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


refreshLiveStatus : Task Never Action
refreshLiveStatus =
  ServerApi.getLiveStatus
    |> Task.map SetLiveStatus


loadRaceReports : Task Never Action
loadRaceReports =
  ServerApi.getRaceReports Nothing
    |> Task.map SetRaceReports
