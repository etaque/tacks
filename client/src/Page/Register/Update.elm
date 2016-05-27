module Page.Register.Update exposing (..)

import Task exposing (Task, succeed, map, andThen)
import Result exposing (Result(Ok, Err))
import Response exposing (..)
import Form
import Page.Register.Model exposing (..)
import ServerApi
import Update.Utils exposing (..)
import Model.Event as Event


mount : Res Model Msg
mount =
  res initial Cmd.none


update : Msg -> Model -> Res Model Msg
update msg ({form} as model) =
  case msg of
    FormMsg formMsg ->
      case ( formMsg, Form.getOutput form ) of
        ( Form.Submit, Just player ) ->
          res { model | loading = True } (submitCmd player)

        _ ->
          res { model | form = Form.update formMsg model.form } Cmd.none

    SubmitResult result ->
      case result of
        Ok player ->
          res { model | loading = False } Cmd.none
            |> withEvent (Event.SetPlayer player)
        Err errors ->
          res { model | loading = False, serverErrors = errors } Cmd.none


submitCmd : NewPlayer -> Cmd Msg
submitCmd np =
  ServerApi.postRegister np.email np.handle np.password
    |> Task.map SubmitResult
    |> performSucceed identity

