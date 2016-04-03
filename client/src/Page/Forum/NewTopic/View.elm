module Page.Forum.NewTopic.View (..) where

import Signal exposing (Address)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import Form.Input as Input
import Form
import Route
import Page.Forum.Route exposing (..)
import Page.Forum.NewTopic.Model exposing (..)
import View.Utils exposing (..)
import View.Layout as Layout


view : Address Action -> Model -> List Html
view addr { form, loading } =
  let
    formAddr =
      Signal.forwardTo addr FormAction

    title =
      Form.getFieldAsString "title" form

    content =
      Form.getFieldAsString "content" form

    ( submitClick, submitDisabled ) =
      case Form.getOutput form of
        Just newTopic ->
          ( onClick addr (Submit newTopic), loading )

        Nothing ->
          ( onClick formAddr Form.Submit, Form.isSubmitted form )
  in
    [ Layout.section
        "blue"
        [ linkTo
            (Route.Forum Index)
            [ class "pull-right btn btn-link"
            ]
            [ text "Cancel" ]
        , h1 [] [ text "New topic" ]
        ]
    , Layout.section
        "white"
        [ div
            [ class "form-new-topic form-vertical" ]
            [ div
                [ class "form-group" ]
                [ Input.textInput
                    title
                    formAddr
                    [ class "form-control", placeholder "Title" ]
                ]
            , div
                [ class "form-group" ]
                [ Input.textArea
                    content
                    formAddr
                    [ class "form-control" ]
                ]
            , div
                [ class "preview" ]
                [ Markdown.toHtml (content.value |> Maybe.withDefault "") ]
            , div
                []
                [ button
                    [ class "btn btn-primary pull-right"
                    , disabled submitDisabled
                    , submitClick
                    ]
                    [ text "Submit" ]
                ]
            ]
        ]
    ]
