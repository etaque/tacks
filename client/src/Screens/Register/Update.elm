module Screens.Register.Update where

import Task exposing (Task, succeed, map, andThen)
import Dict exposing (Dict)
import Result exposing (Result(Ok, Err))
import Effects exposing (Effects, Never, none)
import Response exposing (..)

import Form

import AppTypes exposing (..)
import Screens.Register.Model exposing (..)
import ServerApi
import Screens.UpdateUtils as Utils


addr : Signal.Address Action
addr =
  Utils.screenAddr RegisterAction


mount : (Screen, Effects Action)
mount =
  res initial none


update : Action -> Screen -> (Screen, Effects Action)
update action screen =
  case action of

    FormAction fa ->
      let
        newForm = Form.update fa screen.form
      in
        res { screen | form = newForm } none

    Submit newPlayer ->
      taskRes { screen | loading = True } (submitTask newPlayer)

    SubmitResult result ->
      case result of
        Ok player ->
          let
            newScreen = { screen | loading = False }
            effect = Utils.setPlayer player |> Utils.always NoOp
          in
            res newScreen effect
        Err errors ->
          res { screen | loading = False, serverErrors = errors } none

    NoOp ->
      res screen none


submitTask : NewPlayer -> Task Never Action
submitTask np =
  ServerApi.postRegister np.email np.handle np.password
    |> Task.map SubmitResult

