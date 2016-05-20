module Page.Forum.NewTopic.Update exposing (..)

import Response exposing (..)
import Json.Encode as Json
import Form
import Route
import Page.Forum.Decoders exposing (..)
import Page.Forum.Route exposing (..)
import Page.Forum.NewTopic.Model exposing (..)
import ServerApi exposing (getJson, postJson)
import CoreExtra


update : Msg -> Model -> Response Model Msg
update msg ({ form, loading } as model) =
  case msg of
    FormMsg fa ->
      let
        newForm =
          Form.update fa model.form
      in
        res { model | form = newForm } Cmd.none

    Submit newTopic ->
      res { model | loading = True } (createTopic newTopic)

    SubmitResult result ->
      case result of
        Ok _ ->
          -- TODO
          -- Utils.redirect (Route.Forum Index)
          --   |> Cmd.map (\_ -> NoOp)
          --   |> res model
          res model Cmd.none

        Err e ->
          -- TODO err
          res { model | loading = False } Cmd.none

    NoOp ->
      res model Cmd.none


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
      |> CoreExtra.performSucceed SubmitResult
