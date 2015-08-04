module Views.Login where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import State exposing (..)
import Game exposing (..)
import Messages exposing (Translator)
import Inputs exposing (actionsMailbox)
import Forms.Model exposing (..)
import Forms.Update exposing (..)

import Views.Utils exposing (..)


view : Translator -> AppState -> Html
view t state =
  div [ class "login"]
    [ titleWrapper [ h1 [] [ text "Login" ] ]
    , div [ class "container"] [ loginForm t state.forms.login ]
    ]

loginForm : Translator -> LoginForm -> Html
loginForm t form =
  div [ class "row form-login" ]
    [ col4
      [ div [ class "form-group" ]
        [ textInput
          [ placeholder "Email"
          , value form.email
          , onInputFormUpdate (\s -> UpdateLoginForm (\f -> { f | email <- s } ))
          , onEnter submitMailbox.address (SubmitLogin form)
          ]
        ]
      , div [ class "form-group" ]
        [ passwordInput
          [ placeholder "Password"
          , value form.password
          , onInputFormUpdate (\s -> UpdateLoginForm (\f -> { f | password <- s } ))
          , onEnter submitMailbox.address (SubmitLogin form)
          ]
        ]
      , div []
        [ button
          [ class "btn btn-primary btn-block"
          , onClick submitMailbox.address (SubmitLogin form)
          ]
          [ text "Submit" ]
        ]
      ]
    ]
