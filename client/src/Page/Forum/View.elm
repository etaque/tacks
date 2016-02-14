module Page.Forum.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Model exposing (..)
import Model.Shared exposing (..)
import Model.Forum exposing (..)

import Page.Forum.Route exposing (..)
import Page.Forum.Model exposing (..)
import Page.Forum.Update exposing (addr)

import View.Utils exposing (..)
import View.Layout as Layout


view : Context -> Route -> Model -> Html
view ctx route {topics} =
  Layout.layoutWithNav "forum" ctx
    [ text "TODO" ]

topicsTable : List Topic -> Html
topicsTable posts =
  table
    []
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
        (List.map topicRow posts)
    ]

topicRow : Topic -> Html
topicRow topic =
  tr
    []
    [ td [ class "title" ] [ text topic.title ]
    , td [ class "replies" ] [ text "?" ]
    , td [ class "activity" ] [ text "?" ]
    ]
