module Page.Forum.NewTopic.View where

import Signal exposing (Address)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Date
import Date.Format as DateFormat

import Route

import Page.Forum.Route exposing (..)
import Page.Forum.NewTopic.Model exposing (..)
-- import Page.Forum.Update exposing (addr)

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
    , div []
      [ button
        [ class "btn btn-primary"
        -- , disabled loading
        , onClick addr Submit
        ]
        [ text "Submit" ]
      ]
    ]

