module Page.Forum.ShowTopic.Update exposing (..)

import Response exposing (..)
import Json.Encode as JsEncode
import CoreExtra
import Model.Shared exposing (httpResultToData, RemoteData(..))
import Page.Forum.Decoders exposing (..)
import Page.Forum.Model.Shared exposing (..)
import Page.Forum.ShowTopic.Model exposing (..)
import ServerApi
import Http
import Update.Utils exposing (..)


mount : String -> Response Model Msg
mount id =
    res initial (showTopic id)


update : Msg -> Model -> Response Model Msg
update msg ({ topicWithPosts, response } as model) =
    case msg of
        LoadResult result ->
            res { model | topicWithPosts = httpResultToData result } Cmd.none

        ToggleResponse ->
            case response of
                Just _ ->
                    res { model | response = Nothing } Cmd.none

                Nothing ->
                    res { model | response = Just "" } Cmd.none

        SetContent c ->
            res { model | response = Just c } Cmd.none

        SubmitResponse ->
            case ( topicWithPosts, response ) of
                ( DataOk { topic }, Just c ) ->
                    res { model | submitting = True } (createPost topic c)

                _ ->
                    res model Cmd.none

        SubmitResponseResult result ->
            case ( result, topicWithPosts ) of
                ( Ok postWithUser, DataOk ({ topic, postsWithUsers } as topicWithPosts) ) ->
                    let
                        newTopicWithPosts =
                            { topicWithPosts | postsWithUsers = postsWithUsers ++ [ postWithUser ] }

                        newModel =
                            { model | submitting = False, topicWithPosts = DataOk newTopicWithPosts, response = Nothing }
                    in
                        res newModel Cmd.none

                ( Err _, DataOk _ ) ->
                    -- TODO tell error
                    res { model | submitting = False } Cmd.none

                _ ->
                    res model Cmd.none

        NoOp ->
            res model Cmd.none


createPost : Topic -> String -> Cmd Msg
createPost topic content =
    let
        body =
            JsEncode.object
                [ ( "content", JsEncode.string content ) ]
    in
        Http.post ("/api/forum/topics/" ++ topic.id) (Http.jsonBody body) postWithUserDecoder
            |> ServerApi.sendForm SubmitResponseResult


showTopic : String -> Cmd Msg
showTopic id =
    Http.get ("/api/forum/topics/" ++ id) topicWithPostsDecoder
        |> Http.send LoadResult
