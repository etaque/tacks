module Page.Login.Update exposing (..)

import Task exposing (Task, succeed, map, andThen)
import Result exposing (Result(Ok, Err))
import Response exposing (..)
import Page.Login.Model exposing (..)
import ServerApi
import Update.Utils exposing (..)
import Model.Event as Event


mount : Res Model Msg
mount =
    res initial Cmd.none


update : Msg -> Model -> Res Model Msg
update msg model =
    case msg of
        SetEmail e ->
            res { model | email = e } Cmd.none

        SetPassword p ->
            res { model | password = p } Cmd.none

        Submit ->
            res { model | loading = True } (submitCmd model)

        SubmitResult result ->
            case result of
                Ok player ->
                    let
                        newModel =
                            { model | loading = False, error = False }
                    in
                        res newModel Cmd.none
                            |> withEvent (Event.SetPlayer player)

                Err formErrors ->
                    res { model | loading = False, error = True } Cmd.none

        NoOp ->
            res model Cmd.none


submitCmd : Model -> Cmd Msg
submitCmd model =
    ServerApi.postLogin model.email model.password
        |> Task.map SubmitResult
        |> performSucceed identity
