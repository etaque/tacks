module Screens.ShowTrack.Updates where

import Task exposing (Task, succeed, map, andThen)
import Result exposing (Result(Ok, Err))
import Effects exposing (Effects, Never, none)

import AppTypes exposing (..)
import Screens.ShowTrack.Types exposing (..)
import ServerApi
import Screens.UpdateUtils as Utils


addr : Signal.Address Action
addr =
  Utils.screenAddr ShowTrackAction


mount : String -> (Screen, Effects Action)
mount slug =
  initial &! (loadTrack slug)


update : Action -> Screen -> (Screen, Effects Action)
update action screen =
  case action of

    LoadTrack result ->
      case result of
        Ok track ->
          { screen | track = Just track } &: none
        Err _ ->
          { screen | notFound = True } &: none

    NoOp ->
      screen &: none


loadTrack : String -> Task Never Action
loadTrack slug =
  ServerApi.getTrack slug
    |> Task.map LoadTrack
