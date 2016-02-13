module Page.Register.Update where

import Task exposing (Task, succeed, map, andThen)
import Dict exposing (Dict)
import Result exposing (Result(Ok, Err))
import Effects exposing (Effects, Never, none)
import Response exposing (..)

import Form

import Model exposing (..)
import Page.Register.Model exposing (..)
import ServerApi
import Update.Utils as Utils


addr : Signal.Address Action
addr =
  Utils.pageAddr RegisterAction


mount : (Model, Effects Action)
mount =
  res initial none


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of

    FormAction fa ->
      let
        newForm = Form.update fa model.form
      in
        res { model | form = newForm } none

    Submit newPlayer ->
      taskRes { model | loading = True } (submitTask newPlayer)

    SubmitResult result ->
      case result of
        Ok player ->
          let
            newModel = { model | loading = False }
            effect = Utils.setPlayer player |> Utils.always NoOp
          in
            res newModel effect
        Err errors ->
          res { model | loading = False, serverErrors = errors } none

    NoOp ->
      res model none


submitTask : NewPlayer -> Task Never Action
submitTask np =
  ServerApi.postRegister np.email np.handle np.password
    |> Task.map SubmitResult

