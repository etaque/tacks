module Screens.Register.Updates where

import Task exposing (Task, succeed, map, andThen)
import Dict exposing (Dict)
import Result exposing (Result(Ok, Err))
import Effects exposing (Effects, Never, none)

import AppTypes exposing (..)
import Screens.Register.Types exposing (..)
import ServerApi
import Screens.UpdateUtils as Utils


addr : Signal.Address Action
addr =
  Utils.screenAddr RegisterAction


mount : (Screen, Effects Action)
mount =
  initial &: none


update : Action -> Screen -> (Screen, Effects Action)
update action screen =
  case action of

    SetHandle h ->
      { screen | handle = h } &: none

    SetEmail e ->
      { screen | email = e } &: none

    SetPassword p ->
      { screen | password = p } &: none

    Submit ->
      { screen | loading = True, errors = Dict.empty } &! (submitTask screen)

    SubmitResult result ->
      case result of
        Ok player ->
          let
            newScreen = { screen | loading = False, errors = Dict.empty }
            effect = Utils.setPlayer player |> Utils.always NoOp
          in
            newScreen &: effect
        Err errors ->
          { screen | loading = False, errors = errors } &: none

    NoOp ->
      screen &: none


submitTask : Screen -> Task Never Action
submitTask screen =
  ServerApi.postRegister screen.email screen.handle screen.password
    |> Task.map SubmitResult

