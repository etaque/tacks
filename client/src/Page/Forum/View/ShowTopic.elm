module Page.Forum.View.ShowTopic where

import Signal exposing (Address)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Page.Forum.Model exposing (..)
import Page.Forum.Model.Shared exposing (..)
import Page.Forum.Update exposing (addr)
import Page.Forum.NewPost.View as NewPost

import View.Utils exposing (..)


view : Model -> Html
view model =
  case model.currentTopic of
    Nothing ->
      container "forum-show-topic"
        [ h1 [] [ text "Loading topic..." ]
        ]
    Just {topic, postsWithUsers} ->
      container "forum-show-topic"
        [ h1 [] [ text topic.title ]
        , div [ class "forum-topic-posts" ] (List.map renderPost postsWithUsers)
        , case model.newPost of
            Nothing ->
              button
                [ class "btn btn-primary"
                , onClick addr ToggleNewPost
                ]
                [ text "Response" ]
            Just newPost ->
              NewPost.view (Signal.forwardTo addr NewPostAction) newPost
        ]


renderPost : PostWithUser -> Html
renderPost {post, user} =
  div
    [ class "forum-post"]
    [ div
        [ class "post-meta" ]
        [ div [ class "handle" ] [ text user.handle ]
        , div [ class "time" ] [ text (toString post.creationTime) ]
        ]
    , div
        [ class "post-content" ]
        [ text post.content ]
    ]

