module Page.Forum.Index.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date
import Date.Format as DateFormat
import Model.Shared exposing (Context, asPlayer)
import Route
import Page.Forum.Route exposing (..)
import Page.Forum.Model.Shared exposing (..)
import Page.Forum.Index.Model exposing (..)
import View.Utils as Utils
import View.Layout as Layout
import Location


view : Context -> Model -> List (Html Msg)
view ctx ({ topics } as model) =
  [ Layout.header
      ctx
      []
      [ h1 [] [ text "Forum" ]
      , Utils.linkTo
          (Route.Forum NewTopic)
          [ class "btn-raised btn-positive btn-new-topic cta"
          ]
          [ text "New topic" ]
      ]
  , Layout.section
      [ class "white" ]
      [ topicsTable topics ]
  ]


topicsTable : List TopicWithUser -> (Html Msg)
topicsTable topics =
  table
    [ class "table forum-topics-table" ]
    [ thead
        []
        [ tr
            []
            [ th [ class "icon" ] [  ]
            , th [ class "title-with-author" ] [ text "Topic" ]
            , th [ class "count" ] [ text "Replies" ]
            , th [ class "activity" ] [ text "Most recent" ]
            ]
        ]
    , tbody
        []
        (List.map topicRow topics)
    ]


topicRow : TopicWithUser -> Html Msg
topicRow { topic, user } =
  tr
    (Location.linkAttrs (Route.Forum (ShowTopic topic.id)))
    [ td
        [ class "icon" ]
        [ img [ src (Utils.avatarUrl 32 (asPlayer user)), class "avatar" ] [] ]
    , td
        [ class "title-with-author" ]
        [ div [ class "title" ] [ text topic.title ]
        , div [ class "handle" ] [ text (Utils.playerHandle (asPlayer user)) ]
        ]
    , td
        [ class "count" ]
        [ text (toString (topic.postsCount - 1)) ]
    , td
        [ class "activity" ]
        [ text <| (Date.fromTime >> DateFormat.format "%d %B %Y %H:%I") topic.activityTime ]
    ]
