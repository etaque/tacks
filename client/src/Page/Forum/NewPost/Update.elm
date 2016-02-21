module Page.Forum.NewPost.Update where

import Signal exposing (Address)
import Task exposing (Task, succeed, andThen)
import Effects exposing (Effects, Never, none, map)
import Response exposing (..)
import Json.Encode as JsEncode

import Page.Forum.Decoders exposing (..)
import Page.Forum.Model as Forum
import Page.Forum.NewPost.Model exposing (..)
import ServerApi exposing (getJson, postJson)


update : Action -> Address Forum.Action -> Model -> Response Model Action
update action forumAddr ({topic, content} as model) =
  case action of

    SetContent c ->
      res { model | content = c } none

    Submit ->
      taskRes { model | loading = True } (createPost model)

    SubmitResult result ->
      case result of
        Ok postWithUser ->
          let
            task = Signal.send forumAddr (Forum.AppendPost postWithUser)
              |> Task.map (\_ -> NoOp)
          in
            taskRes { model | loading = False, content = "" } task
        Err _ ->
          -- TODO tell error
          res { model | loading = False } none

    NoOp ->
      res model none


createPost : Model -> Task Never Action
createPost {topic, content} =
  let
    body = JsEncode.object
      [ ("content", JsEncode.string content) ]
  in
    postJson postWithUserDecoder ("/api/forum/topics/" ++ topic.id) body
      |> Task.map SubmitResult
