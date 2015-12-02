module Screens.Login.View where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Screens.Login.Types exposing (..)
import Screens.Login.Updates exposing (addr)

import Screens.Utils exposing (..)


view : Screen -> Html
view screen =
  div [ class "login"]
    [ h1 [] [ text "Login" ]
    , loginForm screen
    ]

loginForm : Screen -> Html
loginForm {email, password, loading, error} =
  div [ class "form-login" ]
    [ div [ class "form-group" ]
      [ textInput
        [ placeholder "Email"
        , value email
        , onInput addr SetEmail
        , onEnter addr Submit
        ]
      ]
    , div [ class "form-group" ]
      [ passwordInput
        [ placeholder "Password"
        , value password
        , onInput addr SetPassword
        , onEnter addr Submit
        ]
      ]
    , errorLine error
    , div []
      [ button
        [ class "btn btn-primary"
        , disabled loading
        , onClick addr Submit
        ]
        [ text "Submit" ]
      ]
    ]

errorLine : Bool -> Html
errorLine error =
  if error then
    p [ class "form-errors alert alert-danger" ] [ text "Login failure. Wrong credentials?" ]
  else
    div [ ] [ ]
