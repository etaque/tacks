module Page.Forum.ShowTopic.View (..) where

import Signal exposing (Address)
import String
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
import View.Layout as Layout


view : Address Action -> Model -> List Html
view addr model =
  case model.currentTopic of
    Nothing ->
      [ Layout.section
          [ class "blue" ]
          [ back
          , h1 [] [ text "Loading topic..." ]
          ]
      ]

    Just { topic, postsWithUsers } ->
      [ Layout.section
          [ class "blue" ]
          [ back
          , h1 [] [ text topic.title ]
          ]
      , Layout.section
          [ class "white" ]
          [ div
              [ class "forum-topic-posts" ]
              (List.map renderPost postsWithUsers)
          , case model.newPostContent of
              Just content ->
                newPost addr content model.loading

              Nothing ->
                button
                  [ class "btn btn-primary pull-right toggle-new-post"
                  , onClick addr ToggleNewPost
                  ]
                  [ text "Reply" ]
          ]
      ]


back : Html
back =
  linkTo
    (Route.Forum Index)
    [ class "btn btn-link pull-right" ]
    [ text "Back" ]


renderPost : PostWithUser -> Html
renderPost { post, user } =
  div
    [ class "forum-post" ]
    [ div
        [ class "post-meta" ]
        [ div [ class "handle" ] [ text user.handle ]
        , div [ class "time" ] [ text (DateFormat.format "%d %B %Y - %H:%I" (Date.fromTime post.creationTime)) ]
        ]
    , div
        [ class "post-content" ]
        [ Markdown.toHtml post.content ]
    ]


newPost : Address Action -> String -> Bool -> Html
newPost addr content loading =
  div
    [ class "form-new-post form-vertical" ]
    [ button
        [ class "btn btn-link pull-right"
        , onClick addr ToggleNewPost
        ]
        [ text "Cancel" ]
    , div
        [ class "form-group" ]
        [ textarea
            [ class "form-control"
            , value content
            , onInput addr SetContent
            ]
            []
        ]
    , if String.isEmpty content then
        text ""
      else
        div
          [ class "preview" ]
          [ div [ class "preview-legend" ] [ text "Preview" ]
          , Markdown.toHtml content
          ]
    , div
        []
        [ button
            [ class "btn btn-primary pull-right"
            , disabled (loading || String.isEmpty content)
            , onClick addr Submit
            ]
            [ text "Submit" ]
        ]
    ]
