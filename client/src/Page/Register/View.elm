module Page.Register.View (..) where

import Dict exposing (Dict)
import String
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Form.Input as Input
import Form
import Model.Shared exposing (..)
import Page.Register.Model exposing (..)
import Page.Register.Update exposing (addr)
import View.Utils exposing (..)
import View.Layout as Layout


view : Context -> Model -> Html
view ctx model =
  Layout.siteLayout
    "register"
    ctx
    (Just Layout.Register)
    [ Layout.header
        ctx
        []
        [ h1 [] [ text "Register" ]
        , div [ class "panel" ] [ registerForm model ]
        ]
    ]


registerForm : Model -> Html
registerForm { form, loading, serverErrors } =
  let
    formAddr =
      Signal.forwardTo addr FormAction

    ( submitClick, submitDisabled ) =
      case Form.getOutput form of
        Just newPlayer ->
          ( onClick addr (Submit newPlayer), not loading )

        Nothing ->
          ( onClick formAddr Form.Submit, Form.isSubmitted form )

    getServerErrors field =
      Dict.get field serverErrors |> Maybe.withDefault []

    isFilled field =
      Maybe.map (String.isEmpty >> not) field.value |> Maybe.withDefault False

    group name label' hint renderer =
      let
        field =
          Form.getFieldAsString name form
      in
        fieldGroup
          ("register_" ++ name)
          label'
          hint
          (errList field.liveError ++ (getServerErrors name))
          [ renderer
              field
              formAddr
              [ classList
                  [ ( "form-control", True )
                  , ( "filled", isFilled field )
                  ]
              , id ("register_" ++ name)
              ]
          ]
  in
    div
      [ class "form-login" ]
      [ group
          "handle"
          "Handle"
          "Alphanumeric, at least 4 chars"
          Input.textInput
      , group
          "email"
          "Email"
          ""
          Input.textInput
      , group
          "password"
          "Password"
          ""
          Input.passwordInput
      , button
          [ class "btn-raised btn-primary btn-block"
          , submitClick
            -- , disabled submitDisabled
          ]
          [ text "Submit" ]
      ]
