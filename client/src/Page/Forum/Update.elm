module Page.Forum.Update where

import Task exposing (Task, succeed, andThen)
import Signal
import Effects exposing (Effects, Never, none, map)
import Response exposing (..)

import Model exposing (..)
import Model.Shared exposing (..)
import Page.Forum.Model as Types exposing (..)
import ServerApi
import Update.Utils as Utils


addr : Signal.Address Action
addr =
  Utils.pageAddr ForumAction


mount : (Model, Effects Action)
mount =
  taskRes initial loadTopics


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of

    TopicsResult result ->
      let
        topics = Result.withDefault [] result
      in
        res { model | topics = topics } none

    NoOp ->
      res model none


loadTopics : Task Never Action
loadTopics =
  ServerApi.getForumTopics
    |> Task.map TopicsResult
