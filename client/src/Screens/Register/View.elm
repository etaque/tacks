module Screens.Register.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dict exposing (Dict)
import String

import Models exposing (..)
import AppTypes exposing (..)
import CoreExtra exposing (..)

import Screens.Register.Types exposing (..)
import Screens.Register.Updates exposing (actions)

import Screens.Utils exposing (..)


view : Screen -> Html
view screen =
  div [ class "register"]
    [ titleWrapper [ h1 [] [ text "Register" ] ]
    , div [ class "container"] [ registerForm screen ]
    ]

registerForm : Screen -> Html
registerForm {handle, email, password, loading, errors} =
  div [ class "row form-login" ]
    [ whitePanel
      [ formGroup (hasError errors "handle")
        [ label [] [ text "Handle" ]
        , textInput
          [ value handle
          , onInput actions.address SetHandle
          , onEnter actions.address Submit
          ]
        , fieldError errors "handle"
        ]
      , formGroup (hasError errors "email")
        [ label [] [ text "Email" ]
        , textInput
          [ value email
          , onInput actions.address SetEmail
          , onEnter actions.address Submit
          ]
        , fieldError errors "email"
        ]
      , formGroup (hasError errors "password")
        [ label [] [ text "Password" ]
        , passwordInput
          [ value password
          , onInput actions.address SetPassword
          , onEnter actions.address Submit
          ]
        , fieldError errors "password"
        ]
      , div []
        [ button
          [ class "btn btn-primary btn-block"
          , onClick actions.address Submit
          , disabled loading
          ]
          [ text "Submit" ]
        ]
      ]
    ]

hasError : FormErrors -> String -> Bool
hasError formErrors field =
  isJust (Dict.get field formErrors)


fieldError : FormErrors -> String -> Html
fieldError formErrors field =
  case Dict.get field formErrors of
    Just fieldErrors ->
      div [ class "error-message" ] [ text (String.join ", " fieldErrors) ]
    Nothing ->
      span [ ] [ ]
