module Page.Forum.NewTopic.View (..) where

import Signal exposing (Address)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Form.Input as Form
import Form.Field as Form
import Form
import Model.Shared exposing (Context)
import Route
import Page.Forum.Route exposing (..)
import Page.Forum.NewTopic.Model exposing (..)
import View.Utils as Utils
import View.Layout as Layout


view : Address Action -> Context -> Model -> List Html
view addr ctx { form, loading } =
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
    [ Layout.header
        ctx
        []
        [ Utils.linkTo
            (Route.Forum Index)
            [ class "action-title"
            , Html.Attributes.title "Back to forum index"
            ]
            [ Utils.mIcon "close" []
            , h1 [] [ text "New topic" ]
            ]
        ]
    , Layout.section
        [ class "white" ]
        [ div
            [ class "form-sheet form-new-topic" ]
            [ div
                [ class "form-group" ]
                [ Form.textInput
                    title
                    formAddr
                    [ class "form-control"
                    , placeholder "Title"
                    ]
                ]
            , div
                [ class "form-group" ]
                [ Form.baseInput
                    "hidden"
                    Form.Text
                    content
                    formAddr
                    [ id "new-topic-body" ]
                , node
                    "trix-editor"
                    [ attribute "input" "new-topic-body" ]
                    []
                ]
            , div
                [ class "form-actions" ]
                [ button
                    [ class "btn-flat"
                    , disabled submitDisabled
                    , submitClick
                    ]
                    [ text "Submit" ]
                ]
            ]
        ]
    ]
