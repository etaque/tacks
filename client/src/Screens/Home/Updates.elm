module Screens.Home.Updates where

import Task exposing (Task, succeed, andThen)
import Task.Extra exposing (delay)
import Time exposing (second)
import Signal
import Effects exposing (Effects, Never, none, map)

import AppTypes exposing (..)
import Models exposing (..)
import Screens.Home.Types exposing (..)
import ServerApi
import Routes
import Screens.UpdateUtils as Utils


addr : Signal.Address Action
addr =
  Utils.screenAddr HomeAction


mount : Player -> (Screen, Effects Action)
mount player =
  taskRes (initial player) refreshLiveStatus


update : Action -> Screen -> (Screen, Effects Action)
update action screen =
  case action of

    SetLiveStatus result ->
      let
        liveStatus = Result.withDefault screen.liveStatus result
      in
        delay (5 * second) refreshLiveStatus
          |> taskRes { screen | liveStatus = liveStatus }

    SetHandle handle ->
      res { screen | handle = handle } none

    SubmitHandle ->
      Task.map SubmitHandleResult (ServerApi.postHandle screen.handle)
        |> taskRes screen

    SubmitHandleResult result ->
      Result.map (Utils.setPlayer) result
        |> Result.withDefault none
        |> Utils.always NoOp
        |> res screen

    FocusTrack maybeTrackId ->
      res { screen | trackFocus = maybeTrackId } none

    NoOp ->
      res screen none


refreshLiveStatus : Task Never Action
refreshLiveStatus =
  ServerApi.getLiveStatus
    |> Task.map SetLiveStatus

