module Page.Forum.ShowTopic.Update exposing (..)

import Response exposing (..)
import Json.Encode as JsEncode
import CoreExtra
import Page.Forum.Decoders exposing (..)
import Page.Forum.Model.Shared exposing (..)
import Page.Forum.ShowTopic.Model exposing (..)
import ServerApi exposing (getJson, postJson)


mount : String -> Response Model Msg
mount id =
  res initial (showTopic id)


update : Msg -> Model -> Response Model Msg
update msg ({currentTopic, newPostContent} as model) =
  case msg of

    LoadResult result ->
      case result of
        Ok topic ->
          res { model | currentTopic = Just topic } Cmd.none
        Err _ ->
          -- TODO
          res model Cmd.none

    ToggleNewPost ->
      case newPostContent of
        Just _ ->
          res { model | newPostContent = Nothing } Cmd.none
        Nothing ->
          res { model | newPostContent = Just "" } Cmd.none

    SetContent c ->
      res { model | newPostContent = Just c } Cmd.none

    Submit ->
      case (currentTopic, newPostContent) of
        (Just {topic}, Just c) ->
          res { model | loading = True } (createPost topic c)
        _ ->
          res model Cmd.none

    SubmitResult result ->
      case (result, currentTopic) of
        (Ok postWithUser, Just ({topic, postsWithUsers} as topicWithPosts)) ->
          let
            newTopicWithPosts = { topicWithPosts | postsWithUsers = postsWithUsers ++ [ postWithUser ] }
            newModel = { model | loading = False, currentTopic = Just newTopicWithPosts, newPostContent = Nothing }
          in
            res newModel Cmd.none

        (Err _, Just _) ->
          -- TODO tell error
          res { model | loading = False } Cmd.none

        _ ->
          res model Cmd.none

    NoOp ->
      res model Cmd.none


createPost : Topic -> String -> Cmd Msg
createPost topic content =
  let
    body = JsEncode.object
      [ ("content", JsEncode.string content) ]
  in
    postJson postWithUserDecoder ("/api/forum/topics/" ++ topic.id) body
      |> CoreExtra.performSucceed SubmitResult


showTopic : String -> Cmd Msg
showTopic id =
  getJson topicWithPostsDecoder ("/api/forum/topics/" ++ id)
    |> CoreExtra.performSucceed LoadResult
