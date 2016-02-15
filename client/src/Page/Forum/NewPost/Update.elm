module Page.Forum.NewPost.Update where

import Task exposing (Task, succeed, andThen)
import Effects exposing (Effects, Never, none, map)
import Response exposing (..)
import Json.Encode as JsEncode

import Page.Forum.Decoders exposing (..)
import Page.Forum.NewPost.Model exposing (..)
import ServerApi exposing (getJson, postJson)


update : Action -> Model -> Response Model Action
update action ({topic, content} as model) =
  case action of

    SetContent c ->
      res { model | content = c } none

    Submit ->
      taskRes model (createPost model)

    SubmitResult result ->
      res model none


createPost : Model -> Task Never Action
createPost {topic, content} =
  let
    body = JsEncode.object
      [ ("content", JsEncode.string content) ]
  in
    postJson postWithUserDecoder ("/api/forum/topics/" ++ topic.id) body
      |> Task.map SubmitResult
