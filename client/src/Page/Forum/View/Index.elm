module Page.Forum.View.Index where

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
          newTopicForm (Signal.forwardTo addr NewTopicAction) newTopic
        Nothing ->
          topicsTable topics
    ]

newTopicForm : Address NewTopicAction -> NewTopic -> Html
newTopicForm addr {title, content} =
  div [ class "form-new-topic form-vertical" ]
    [ div [ class "form-group" ]
      [ textInput
        [ value title
        , onInput addr SetTitle
        , onEnter addr Submit
        , placeholder "Title"
        ]
      ]
    , div [ class "form-group" ]
      [ textarea
        [ class "form-control"
        , value content
        , onInput addr SetContent
        ]
        [  ]
      ]
    , div []
      [ button
        [ class "btn btn-primary"
        -- , disabled loading
        , onClick addr Submit
        ]
        [ text "Submit" ]
      ]
    ]


topicsTable : List TopicWithUser -> Html
topicsTable topics =
  table
    [ class "table" ]
    [ thead
        []
        [ tr
            []
            [ th [] [ text "Topic" ]
            , th [] [ text "Replies" ]
            , th [] [ text "Activity" ]
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
    [ td [ class "title" ] [ linkTo (Route.Forum (ShowTopic topic.id)) [] [ text topic.title ] ]
    , td [ class "replies" ] [ text (toString topic.postsCount) ]
    , td [ class "activity" ] [ text (toString topic.activityTime) ]
    ]
