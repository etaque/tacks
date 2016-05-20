module Page.Register.Update exposing (..)

import Task exposing (Task, succeed, map, andThen)
import Result exposing (Result(Ok, Err))
import Response exposing (..)
import Form
import Page.Register.Model exposing (..)
import ServerApi
import CoreExtra
import Model.Event as Event


mount : Res Model Msg
mount =
  res initial Cmd.none


update : Msg -> Model -> Res Model Msg
update msg model =
  case msg of

    FormMsg fa ->
      let
        newForm = Form.update fa model.form
      in
        res { model | form = newForm } Cmd.none

    Submit newPlayer ->
      res { model | loading = True } (submitCmd newPlayer)

    SubmitResult result ->
      case result of
        Ok player ->
          res { model | loading = False } Cmd.none
            |> withEvent (Event.SetPlayer player)
        Err errors ->
          res { model | loading = False, serverErrors = errors } Cmd.none

    NoOp ->
      res model Cmd.none


submitCmd : NewPlayer -> Cmd Msg
submitCmd np =
  ServerApi.postRegister np.email np.handle np.password
    |> Task.map SubmitResult
    |> CoreExtra.performSucceed identity

