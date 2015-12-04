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
  initial player &! refreshLiveStatus


update : Action -> Screen -> (Screen, Effects Action)
update action screen =
  case action of

    SetLiveStatus result ->
      let
        liveStatus = result ?: screen.liveStatus
        task = delay (5 * second) refreshLiveStatus
      in
        { screen | liveStatus = liveStatus } &! task

    SetHandle handle ->
      { screen | handle = handle } &: none

    SubmitHandle ->
      let
        task = Task.map SubmitHandleResult (ServerApi.postHandle screen.handle)
      in
        screen &! task

    SubmitHandleResult result ->
      let
        effect = Result.map Utils.setPlayer result ?: none
          |> Utils.always NoOp
      in
        screen &: effect

    CreateTrack ->
      screen &! (Task.map CreateTrackResult ServerApi.createTrack)

    CreateTrackResult result ->
      case result of
        Ok track ->
          screen &: (Utils.redirect (Routes.EditTrack track.id) |> Utils.always NoOp)
        Err formErrors -> -- TODO
          screen &: none

    NoOp ->
      screen &: none


refreshLiveStatus : Task Never Action
refreshLiveStatus =
  ServerApi.getLiveStatus
    |> Task.map SetLiveStatus

