module Page.Register.View (..) where

import Dict exposing (Dict)
import String
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Form.Input as Input
import Form
import Model.Shared exposing (..)
import CoreExtra exposing (..)
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

    handle =
      Form.getFieldAsString "handle" form

    email =
      Form.getFieldAsString "email" form

    password =
      Form.getFieldAsString "password" form

    getServerErrors field =
      Dict.get field serverErrors |> Maybe.withDefault []

    isFilled field =
      Maybe.map (String.isEmpty >> not) field.value |> Maybe.withDefault False
  in
    div
      [ class "form-login" ]
      [ fieldGroup
          "Handle"
          "Alphanumeric, at least 4 chars"
          (errList handle.liveError ++ (getServerErrors "handle"))
          [ Input.textInput
              handle
              formAddr
              [ classList
                  [ ( "form-control", True )
                  , ( "filled", isFilled handle )
                  ]
              ]
          ]
      , fieldGroup
          "Email"
          ""
          (errList email.liveError ++ (getServerErrors "email"))
          [ Input.textInput
              email
              formAddr
              [ classList
                  [ ( "form-control", True )
                  , ( "filled", isFilled email )
                  ]
              ]
          ]
      , fieldGroup
          "Password"
          ""
          (errList password.liveError)
          [ Input.passwordInput
              password
              formAddr
              [ classList
                  [ ( "form-control", True )
                  , ( "filled", isFilled password )
                  ]
              ]
          ]
      , button
          [ class "btn-raised btn-primary btn-block"
          , submitClick
            -- , disabled submitDisabled
          ]
          [ text "Submit" ]
      ]
