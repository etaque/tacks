module Page.Forum.ShowTopic.View where

import Signal exposing (Address)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Markdown

import Route

import Page.Forum.Route exposing (..)
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
        [ back
        , h1 [] [ text "Loading topic..." ]
        ]
    Just {topic, postsWithUsers} ->
      container "forum-show-topic"
        [ back
        , h1 [] [ text topic.title ]
        , div
            [ class "forum-topic-posts" ]
            (List.map renderPost postsWithUsers)
        , button
            [ class "btn btn-primary pull-right toggle-new-post"
            , onClick addr ToggleNewPost
            ]
            [ text "Reply" ]
        , case model.newPost of
            Just newPost ->
              NewPost.view (Signal.forwardTo addr NewPostAction) newPost
            Nothing ->
              text ""
        ]


back : Html
back =
  linkTo
    (Route.Forum Index)
    [ class "btn btn-link pull-right" ]
    [ text "Back" ]


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
        [ Markdown.toHtml post.content ]
    ]

