module Screens.Login.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import AppTypes exposing (..)

import Screens.Login.Types exposing (..)
import Screens.Login.Updates exposing (actions)

import Screens.Utils exposing (..)


view : Screen -> Html
view screen =
  div [ class "login"]
    [ titleWrapper [ h1 [] [ text "Login" ] ]
    , div [ class "container"] [ loginForm screen ]
    ]

loginForm : Screen -> Html
loginForm {email, password, loading, error} =
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
      , errorLine error
      , div []
        [ button
          [ class "btn btn-primary btn-block"
          , disabled loading
          , onClick actions.address Submit
          ]
          [ text "Submit" ]
        ]
      ]
    ]

errorLine : Bool -> Html
errorLine error =
  if error then
    p [ class "form-errors alert alert-danger" ] [ text "Login failure. Wrong credentials?" ]
  else
    div [ ] [ ]
