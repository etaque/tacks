module Screens.Admin.Updates where

import Task exposing (Task, succeed, andThen)
import Signal
import Effects exposing (Effects, Never, none, map)

import Transition

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

    Types.TransitionAction a ->
      Transition.applyStep screen Types.TransitionAction a

    NoOp ->
      screen &: none


refreshData : Task Never Action
refreshData =
  ServerApi.loadAdminData
    |> Task.map RefreshDataResult

