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
import Screens.Register.Updates exposing (addr)

import Screens.Utils exposing (..)
import Screens.Layout as Layout


view : Context -> Screen -> Html
view ctx screen =
  Layout.layoutWithNav "register" ctx
    [ container ""
      [ h1 [] [ text "Register" ]
      , registerForm screen
      ]
    ]

registerForm : Screen -> Html
registerForm {handle, email, password, loading, errors} =
  div [ class "form-login" ]
    [ formGroup (hasError errors "handle")
      [ label [] [ text "Handle" ]
      , textInput
        [ value handle
        , onInput addr SetHandle
        , onEnter addr Submit
        ]
      , fieldError errors "handle"
      ]
    , formGroup (hasError errors "email")
      [ label [] [ text "Email" ]
      , textInput
        [ value email
        , onInput addr SetEmail
        , onEnter addr Submit
        ]
      , fieldError errors "email"
      ]
    , formGroup (hasError errors "password")
      [ label [] [ text "Password" ]
      , passwordInput
        [ value password
        , onInput addr SetPassword
        , onEnter addr Submit
        ]
      , fieldError errors "password"
      ]
    , div []
      [ button
        [ class "btn btn-primary"
        , onClick addr Submit
        , disabled loading
        ]
        [ text "Submit" ]
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
