module Page.Forum.NewTopic.View exposing (..)

import Html.App exposing (map)
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


view : Context -> Model -> List (Html Msg)
view ctx ({ form, loading } as model) =
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
      [ map FormMsg (formView model) ]
  ]


formView : Model -> Html Form.Msg
formView { form, loading } =
  let
    title =
      Form.getFieldAsString "title" form

    content =
      Form.getFieldAsString "content" form

    submitDisabled =
      Form.getOutput form
        |> Maybe.map (\_ -> loading)
        |> Maybe.withDefault (Form.isSubmitted form)
  in
    div
        [ class "form-sheet form-new-topic" ]
        [ div
            [ class "form-group" ]
            [ Form.textInput
                title
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
                , onClick Form.Submit
                ]
                [ text "Submit" ]
            ]
        ]
