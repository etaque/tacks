module Page.Forum.NewTopic.View where

import Signal exposing (Address)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Markdown

import Page.Forum.NewTopic.Model exposing (..)

import View.Utils exposing (..)


view : Address Action -> Model -> Html
view addr {title, content} =
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
    , div
        [ class "preview" ]
        [ Markdown.toHtml content ]
    , div []
      [ button
        [ class "btn btn-primary"
        -- , disabled loading
        , onClick addr Submit
        ]
        [ text "Submit" ]
      ]
    ]

