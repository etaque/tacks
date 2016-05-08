module Page.Forum.ShowTopic.View (..) where

import Signal exposing (Address)
import String
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import Date
import Date.Format as DateFormat
import Model.Shared exposing (Context, asPlayer)
import Route
import Page.Forum.Route exposing (..)
import Page.Forum.Model.Shared exposing (..)
import Page.Forum.ShowTopic.Model exposing (..)
import View.Utils as Utils
import View.Layout as Layout


view : Address Action -> Context -> Model -> List Html
view addr ctx model =
  case model.currentTopic of
    Nothing ->
      [ header ctx "Loading..." ]

    Just { topic, postsWithUsers } ->
      [ header ctx topic.title
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
                  [ class "btn-floating btn-primary toggle-new-post"
                  , onClick addr ToggleNewPost
                  ]
                  [ Utils.mIcon "add" [] ]
          ]
      ]


header : Context -> String -> Html
header ctx title =
  Layout.header
    ctx
    []
    [ Utils.linkTo
        (Route.Forum Index)
        [ class "action-title"
        , Html.Attributes.title "Back to forum index"
        ]
        [ Utils.mIcon "arrow_back" []
        , h1 [] [ text title ]
        ]
    ]


renderPost : PostWithUser -> Html
renderPost { post, user } =
  div
    [ class "forum-post" ]
    [ div
        [ class "post-meta" ]
        [ Utils.playerWithAvatar (asPlayer user)
        , div [ class "time" ] [ text (DateFormat.format "%d %B %Y - %H:%I" (Date.fromTime post.creationTime)) ]
        ]
    , div
        [ class "post-content" ]
        [ Markdown.toHtml post.content ]
    ]


newPost : Address Action -> String -> Bool -> Html
newPost addr content loading =
  div
    [ class "form-sheet" ]
    [ div
        [ class "form-header" ]
        [ div
            [ class "cancel-new-post"
            , onClick addr ToggleNewPost
            ]
            [ Utils.mIcon "close" [] ]
        , h3 [] [ text "New message" ]
        ]
    , div
        [ class "form-group" ]
        [ textarea
            [ class "form-control"
            , placeholder "Message body"
            , value content
            , Utils.onInput addr SetContent
            ]
            []
        ]
      -- , if String.isEmpty content then
      --     text ""
      --   else
      --     div
      --       [ class "preview" ]
      --       [ div [ class "preview-legend" ] [ text "Preview" ]
      --       , Markdown.toHtml content
      --       ]
    , div
        [ class "form-actions" ]
        [ button
            [ class "btn-flat"
            , disabled (loading || String.isEmpty content)
            , onClick addr Submit
            ]
            [ text "Submit" ]
        ]
    ]
