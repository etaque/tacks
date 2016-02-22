module Page.Forum.Index.Update where

import Task exposing (Task, succeed, andThen)
import Effects exposing (Effects, Never, none, map)
import Response exposing (..)
import Json.Decode as Json

import Page.Forum.Decoders exposing (..)
import Page.Forum.Model.Shared exposing (..)
import Page.Forum.Index.Model exposing (..)
import ServerApi exposing (getJson, postJson)


mount : (Model, Effects Action)
mount =
  taskRes initial listTopics


update : Action -> Model -> Response Model Action
update action ({topics} as model) =
  case action of

    RefreshList ->
      taskRes model listTopics

    ListResult result ->
      let
        topics = Result.withDefault [] result
      in
        res { model | topics = topics } none

    NoOp ->
      res model none


listTopics : Task Never Action
listTopics =
  getJson (Json.list topicWithUserDecoder) "/api/forum/topics"
    |> Task.map ListResult
