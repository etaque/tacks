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
  staticRes initial


update : Action -> Screen -> (Screen, Effects Action)
update action screen =
  case action of

    SetHandle h ->
      staticRes { screen | handle = h }

    SetEmail e ->
      staticRes { screen | email = e }

    SetPassword p ->
      staticRes { screen | password = p }

    Submit ->
      taskRes { screen | loading = True, errors = Dict.empty } (submitTask screen)

    SubmitResult result ->
      case result of
        Ok player ->
          let
            newScreen = { screen | loading = False, errors = Dict.empty }
            effect = Utils.setPlayer player |> Utils.always NoOp
          in
            res newScreen effect
        Err errors ->
          staticRes { screen | loading = False, errors = errors }

    NoOp ->
      staticRes screen


submitTask : Screen -> Task Never Action
submitTask screen =
  ServerApi.postRegister screen.email screen.handle screen.password
    |> Task.map SubmitResult

