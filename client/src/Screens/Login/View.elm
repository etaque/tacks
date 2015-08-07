module Screens.Login.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import AppTypes exposing (..)

import Screens.Login.Types exposing (..)
import Screens.Login.Updates exposing (actions)

import Views.Utils exposing (..)


view : Screen -> Html
view screen =
  div [ class "login"]
    [ titleWrapper [ h1 [] [ text "Login" ] ]
    , div [ class "container"] [ loginForm screen ]
    ]

loginForm : Screen -> Html
loginForm {email, password} =
  div [ class "row form-login" ]
    [ whitePanel
      [ div [ class "form-group" ]
        [ textInput
          [ placeholder "Email"
          , value email
          , onInput actions.address SetEmail
          , onEnter actions.address Submit
          ]
        ]
      , div [ class "form-group" ]
        [ passwordInput
          [ placeholder "Password"
          , value password
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
