module Page.Forum.View.ShowTopic where

import Signal exposing (Address)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Route

import Page.Forum.Route exposing (..)
import Page.Forum.Model exposing (..)
import Page.Forum.Update exposing (addr)

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
        ]

renderPost : PostWithUser -> Html
renderPost {post, user} =
  div
    [ class "forum-post"]
    [ div
        [ class "post-meta" ]
        [ text user.handle ]
    , div
        [ class "post-content" ]
        [ text post.content ]
    ]
