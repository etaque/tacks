module Page.Forum.Update exposing (..)

import Response exposing (..)
import Page.Forum.Model exposing (..)
import Page.Forum.Route exposing (..)
import Page.Forum.Index.Update as Index
import Page.Forum.ShowTopic.Update as ShowTopic
import Page.Forum.NewTopic.Update as NewTopic


mount : Route -> Response Model Msg
mount route =
    case route of
        Index ->
            Index.mount
                |> mapBoth (\t -> { initial | index = t }) IndexMsg

        ShowTopic id ->
            ShowTopic.mount id
                |> mapBoth (\t -> { initial | showTopic = t }) ShowTopicMsg

        NewTopic ->
            res initial Cmd.none


update : Msg -> Model -> Response Model Msg
update msg model =
    case msg of
        IndexMsg a ->
            Index.update a model.index
                |> mapBoth (\i -> { model | index = i }) IndexMsg

        NewTopicMsg a ->
            NewTopic.update a model.newTopic
                |> mapBoth (\t -> { model | newTopic = t }) NewTopicMsg

        ShowTopicMsg a ->
            ShowTopic.update a model.showTopic
                |> mapBoth (\t -> { model | showTopic = t }) ShowTopicMsg

        NoOp ->
            res model Cmd.none
