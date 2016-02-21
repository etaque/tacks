module Page.Forum.NewTopic.Update where

import Task exposing (Task, succeed, andThen)
import Signal
import Effects exposing (Effects, Never, none, map)
import Response exposing (..)
import Json.Encode as Json

import Page.Forum.Decoders exposing (..)
import Page.Forum.NewTopic.Model exposing (..)
import ServerApi exposing (getJson, postJson)


update : Action -> Model -> Response Model Action
update action ({title, content} as model) =
  case action of

    SetTitle t ->
      res { model | title = t } none

    SetContent c ->
      res { model | content = c } none

    Submit ->
      taskRes model (createTopic model)

    SubmitResult result ->
      res model none

    NoOp ->
      res model none


createTopic : Model -> Task Never Action
createTopic {title, content} =
  let
    body = Json.object
      [ ("title", Json.string title)
      , ("content", Json.string content)
      ]
  in
    postJson topicDecoder "/api/forum/topics" body
      |> Task.map SubmitResult
