module Page.Forum.ShowTopic.Update where

import Signal exposing (Address)
import Task exposing (Task, succeed, andThen)
import Effects exposing (Effects, Never, none, map)
import Response exposing (..)
import Json.Encode as JsEncode

import Page.Forum.Decoders exposing (..)
import Page.Forum.Model.Shared exposing (..)
import Page.Forum.ShowTopic.Model exposing (..)
import ServerApi exposing (getJson, postJson)


mount : String -> (Model, Effects Action)
mount id =
  taskRes initial (showTopic id)


update : Action -> Model -> Response Model Action
update action ({currentTopic, newPostContent} as model) =
  case action of

    LoadResult result ->
      case result of
        Ok topic ->
          res { model | currentTopic = Just topic } none
        Err _ ->
          -- TODO
          res model none

    ToggleNewPost ->
      case newPostContent of
        Just _ ->
          res { model | newPostContent = Nothing } none
        Nothing ->
          res { model | newPostContent = Just "" } none

    SetContent c ->
      res { model | newPostContent = Just c } none

    Submit ->
      case (currentTopic, newPostContent) of
        (Just {topic}, Just c) ->
          taskRes { model | loading = True } (createPost topic c)
        _ ->
          res model none

    SubmitResult result ->
      case (result, currentTopic) of
        (Ok postWithUser, Just ({topic, postsWithUsers} as topicWithPosts)) ->
          let
            newTopicWithPosts = { topicWithPosts | postsWithUsers = postsWithUsers ++ [ postWithUser ] }
            newModel = { model | loading = False, currentTopic = Just newTopicWithPosts, newPostContent = Nothing }
          in
            res newModel none

        (Err _, Just _) ->
          -- TODO tell error
          res { model | loading = False } none

        _ ->
          res model none

    NoOp ->
      res model none


createPost : Topic -> String -> Task Never Action
createPost topic content =
  let
    body = JsEncode.object
      [ ("content", JsEncode.string content) ]
  in
    postJson postWithUserDecoder ("/api/forum/topics/" ++ topic.id) body
      |> Task.map SubmitResult


showTopic : String -> Task Never Action
showTopic id =
  getJson topicWithPostsDecoder ("/api/forum/topics/" ++ id)
    |> Task.map LoadResult
