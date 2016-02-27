module Page.Forum.Index.View (..) where

import Signal exposing (Address)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date
import Date.Format as DateFormat
import Route
import Page.Forum.Route exposing (..)
import Page.Forum.Model.Shared exposing (..)
import Page.Forum.Index.Model exposing (..)
import View.Utils exposing (..)


view : Address Action -> Model -> Html
view addr ({ topics } as model) =
  container
    "forum-index"
    [ linkTo
        (Route.Forum NewTopic)
        [ class "pull-right btn btn-primary"
        ]
        [ text "New topic" ]
    , h1 [] [ text "Forum" ]
    , topicsTable topics
    ]


topicsTable : List TopicWithUser -> Html
topicsTable topics =
  table
    [ class "table forum-topics-table" ]
    [ thead
        []
        [ tr
            []
            [ th [ class "title" ] [ text "Topic" ]
            , th [ class "original" ] [ text "Started by" ]
            , th [ class "count" ] [ text "Replies" ]
            , th [ class "activity" ] [ text "Most recent" ]
            ]
        ]
    , tbody
        []
        (List.map topicRow topics)
    ]


topicRow : TopicWithUser -> Html
topicRow { topic, user } =
  tr
    []
    [ td
        [ class "title" ]
        [ linkTo (Route.Forum (ShowTopic topic.id)) [] [ text topic.title ] ]
    , td
        [ class "original" ]
        [ text user.handle ]
    , td
        [ class "count" ]
        [ text (toString topic.postsCount) ]
    , td
        [ class "activity" ]
        [ text <| (Date.fromTime >> DateFormat.format "%d %B %Y %H:%I") topic.activityTime ]
    ]
