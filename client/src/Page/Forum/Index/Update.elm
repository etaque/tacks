module Page.Forum.Index.Update exposing (..)

import Response exposing (..)
import Json.Decode as Json
import Update.Utils exposing (..)
import Page.Forum.Decoders exposing (..)
import Page.Forum.Index.Model exposing (..)
import ServerApi exposing (getJson, postJson)


mount : Response Model Msg
mount =
  res initial listTopics


update : Msg -> Model -> Response Model Msg
update msg ({topics} as model) =
  case msg of

    RefreshList ->
      res model listTopics

    ListResult result ->
      let
        topics = Result.withDefault [] result
      in
        res { model | topics = topics } Cmd.none

    NoOp ->
      res model Cmd.none


listTopics : Cmd Msg
listTopics =
  getJson (Json.list topicWithUserDecoder) "/api/forum/topics"
    |> performSucceed ListResult
