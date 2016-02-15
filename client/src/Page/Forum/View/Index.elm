module Page.Forum.View.Index where

import Signal exposing (Address)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Date
import Date.Format as DateFormat

import Route

import Page.Forum.Route exposing (..)
import Page.Forum.Model exposing (..)
import Page.Forum.Model.Shared exposing (..)
import Page.Forum.Update exposing (addr)
import Page.Forum.NewTopic.View as NewTopic

import View.Utils exposing (..)


view : Model -> Html
view ({topics} as model) =
  container "forum-index"
    [ h1 [] [ text "Forum"]
    , button
        [ class "btn btn-primary"
        , onClick addr ShowNewTopic
        ]
        [ text "New topic" ]
    , case model.newTopic of
        Just newTopic ->
          NewTopic.view (Signal.forwardTo addr NewTopicAction) newTopic
        Nothing ->
          topicsTable topics
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
topicRow {topic, user} =
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
        [ text <| (Date.fromTime >> DateFormat.format "%B %d %H:%M") topic.activityTime ]
    ]
