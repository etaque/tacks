module Page.Forum.Update where

import Effects exposing (Effects, Never, none, map)
import Response exposing (..)

import Model exposing (..)
import Page.Forum.Model exposing (..)
import Page.Forum.Route exposing (..)
import Page.Forum.Index.Update as Index
import Page.Forum.ShowTopic.Update as ShowTopic
import Page.Forum.NewTopic.Update as NewTopic
import Update.Utils as Utils


addr : Signal.Address Action
addr =
  Utils.pageAddr ForumAction


mount : Route -> (Model, Effects Action)
mount route =
  case route of
    Index ->
      Index.mount
        |> mapBoth (\t -> { initial | index = t }) IndexAction
    ShowTopic id ->
      ShowTopic.mount id
        |> mapBoth (\t -> { initial | showTopic = t }) ShowTopicAction
    NewTopic ->
      res initial none


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of

    IndexAction a ->
      Index.update a model.index
        |> mapBoth (\i -> { model | index = i }) IndexAction

    NewTopicAction a ->
      NewTopic.update a model.newTopic
        |> mapBoth (\t -> { model | newTopic = t }) NewTopicAction

    ShowTopicAction a ->
      ShowTopic.update a model.showTopic
        |> mapBoth (\t -> { model | showTopic = t }) ShowTopicAction

    NoOp ->
      res model none

