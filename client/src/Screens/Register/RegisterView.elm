module Screens.Register.RegisterView where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import AppTypes exposing (..)

import Screens.Register.RegisterTypes exposing (..)
import Screens.Register.RegisterUpdates exposing (actions)

import Views.Utils exposing (..)


view : Screen -> Html
view screen =
  div [ class "register"]
    [ titleWrapper [ h1 [] [ text "Register" ] ]
    , div [ class "container"] [ registerForm screen ]
    ]

registerForm : Screen -> Html
registerForm {handle, email, password} =
  div [ class "row form-login" ]
    [ whitePanel
      [ div [ class "form-group" ]
        [ label [] [ text "Handle" ]
        , textInput
          [ value handle
          , onInput actions.address SetHandle
          , onEnter actions.address Submit
          ]
        ]
      , div [ class "form-group" ]
        [ label [] [ text "Email" ]
        , textInput
          [ placeholder "Email"
          , value email
          , onInput actions.address SetEmail
          , onEnter actions.address Submit
          ]
        ]
      , div [ class "form-group" ]
        [ label [] [ text "Password" ]
        , passwordInput
          [ value password
          , onInput actions.address SetPassword
          , onEnter actions.address Submit
          ]
        ]
      , div []
        [ button
          [ class "btn btn-primary btn-block"
          , onClick actions.address Submit
          ]
          [ text "Submit" ]
        ]
      ]
    ]
