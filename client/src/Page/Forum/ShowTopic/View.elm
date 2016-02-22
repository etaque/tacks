module Page.Forum.ShowTopic.View where

import Signal exposing (Address)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Markdown
import Date
import Date.Format as DateFormat

import Route

import Page.Forum.Route exposing (..)
import Page.Forum.Model.Shared exposing (..)
import Page.Forum.ShowTopic.Model exposing (..)

import View.Utils exposing (..)


view : Address Action -> Model -> Html
view addr model =
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
        , case model.newPostContent of
            Just content ->
              newPost addr content model.loading
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
        , div [ class "time" ] [ text (DateFormat.format "%d %B %Y - %H:%I" (Date.fromTime post.creationTime)) ]
        ]
    , div
        [ class "post-content" ]
        [ Markdown.toHtml post.content ]
    ]


newPost : Address Action ->  String -> Bool -> Html
newPost addr content loading =
  div [ class "form-new-post form-vertical" ]
    [ div
        [ class "form-group" ]
        [ textarea
          [ class "form-control"
          , value content
          , onInput addr SetContent
          ]
          [  ]
        ]
    , div
        [ class "preview" ]
        [ Markdown.toHtml content ]
    , div
        []
        [ button
          [ class "btn btn-default pull-right"
          , disabled loading
          , onClick addr Submit
          ]
          [ text "Submit" ]
        ]
    ]
