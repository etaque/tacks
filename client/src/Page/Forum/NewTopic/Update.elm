module Page.Forum.NewTopic.Update exposing (..)

import Response exposing (..)
import Json.Encode as Json
import Form
import Route
import Page.Forum.Decoders exposing (..)
import Page.Forum.Route exposing (..)
import Page.Forum.NewTopic.Model exposing (..)
import ServerApi exposing (getJson, postJson)
import Update.Utils exposing (..)


update : Msg -> Model -> Response Model Msg
update msg ({ form, loading } as model) =
    case msg of
        FormMsg formMsg ->
            case ( formMsg, Form.getOutput form ) of
                ( Form.Submit, Just topic ) ->
                    res { model | loading = True } (createTopic topic)

                _ ->
                    res { model | form = Form.update formMsg model.form } Cmd.none

        SubmitResult result ->
            case result of
                Ok _ ->
                    res model (navigate (Route.Forum Index))

                Err e ->
                    -- TODO err
                    res { model | loading = False } Cmd.none


createTopic : NewTopic -> Cmd Msg
createTopic { title, content } =
    let
        body =
            Json.object
                [ ( "title", Json.string title )
                , ( "content", Json.string content )
                ]
    in
        postJson topicDecoder "/api/forum/topics" body
            |> performSucceed SubmitResult
