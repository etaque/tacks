module Page.Forum.NewTopic.Update where

import Task exposing (Task, succeed, andThen)
import Signal
import Effects exposing (Effects, Never, none, map)
import Response exposing (..)
import Json.Decode as Json
import Json.Encode as JsEncode

import Page.Forum.Decoders exposing (..)
import Page.Forum.NewTopic.Model exposing (..)
import ServerApi exposing (getJson, postJson)


update : Action -> Model -> Response Model Action
update action ({title, content} as newTopic) =
  case action of

    SetTitle t ->
      res { newTopic | title = t } none

    SetContent c ->
      res { newTopic | content = c } none

    Submit ->
      taskRes newTopic (createTopic newTopic)

    SubmitResult result ->
      res newTopic none


createTopic : Model -> Task Never Action
createTopic {title, content} =
  let
    body = JsEncode.object
      [ ("title", JsEncode.string title)
      , ("content", JsEncode.string content)
      ]
  in
    postJson topicDecoder "/api/forum/topics" body
      |> Task.map SubmitResult
