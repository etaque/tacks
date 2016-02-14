module Page.Forum.Update where

import Task exposing (Task, succeed, andThen)
import Signal
import Effects exposing (Effects, Never, none, map)
import Response exposing (..)
import Json.Decode as Json
import Json.Encode as JsEncode

import Model exposing (..)
import Model.Shared exposing (..)
import Page.Forum.Model exposing (..)
import Page.Forum.Decoders exposing (..)
import Page.Forum.Route exposing (..)
import ServerApi exposing (getJson, postJson)
import Update.Utils as Utils


addr : Signal.Address Action
addr =
  Utils.pageAddr ForumAction


mount : Route -> (Model, Effects Action)
mount route =
  case route of
    Index ->
      taskRes initial listTopics
    ShowTopic id ->
      taskRes initial (showTopic id)


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of

    RefreshList ->
      taskRes model listTopics

    ListResult result ->
      let
        topics = Result.withDefault [] result
      in
        res { model | topics = topics } none

    ShowResult result ->
      case result of
        Ok topic ->
          res { model | currentTopic = Just topic } none
        Err _ ->
          -- TODO
          res model none

    ShowNewTopic ->
      let
        newTopic = { title = "", content = "" }
      in
        res { model | newTopic = Just newTopic } none

    HideNewTopic ->
      res { model | newTopic = Nothing } none

    NewTopicAction a ->
      case model.newTopic of
        Just newTopic ->
          updateNewTopic a newTopic
            |> mapModel (\t -> { model | newTopic = Just t })
            |> mapEffects NewTopicAction
        Nothing ->
          res model none

    NoOp ->
      res model none


updateNewTopic : NewTopicAction -> NewTopic -> (NewTopic, Effects NewTopicAction)
updateNewTopic action ({title, content} as newTopic) =
  case action of

    SetTitle t ->
      res { newTopic | title = t } none

    SetContent c ->
      res { newTopic | content = c } none

    Submit ->
      taskRes newTopic (createTopic newTopic)

    SubmitResult result ->
      res newTopic none


listTopics : Task Never Action
listTopics =
  getJson (Json.list topicWithUserDecoder) "/api/forum/topics"
    |> Task.map ListResult


showTopic : Id -> Task Never Action
showTopic id =
  getJson topicWithPostsDecoder ("/api/forum/topics/" ++ id)
    |> Task.map ShowResult


createTopic : NewTopic -> Task Never NewTopicAction
createTopic {title, content} =
  let
    body = JsEncode.object
      [ ("title", JsEncode.string title)
      , ("content", JsEncode.string content)
      ]
  in
    postJson topicDecoder "/api/forum/topics" body
      |> Task.map SubmitResult
