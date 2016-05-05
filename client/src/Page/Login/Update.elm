module Page.Login.Update (..) where

import Task exposing (Task, succeed, map, andThen)
import Result exposing (Result(Ok, Err))
import Effects exposing (Effects, Never, none)
import Response exposing (..)
import Model
import Page.Login.Model exposing (..)
import ServerApi
import Update.Utils as Utils


addr : Signal.Address Action
addr =
  Utils.pageAddr Model.LoginAction


mount : ( Model, Effects Action )
mount =
  res initial none


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    SetEmail e ->
      res { model | email = e } none

    SetPassword p ->
      res { model | password = p } none

    Submit ->
      taskRes { model | loading = True } (submitTask model)

    SubmitResult result ->
      case result of
        Ok player ->
          let
            newModel =
              { model | loading = False, error = False }

            effect =
              Utils.setPlayer player |> Utils.always NoOp
          in
            res newModel effect

        Err formErrors ->
          res { model | loading = False, error = True } none

    NoOp ->
      res model none


submitTask : Model -> Task Never Action
submitTask model =
  ServerApi.postLogin model.email model.password
    |> Task.map SubmitResult
