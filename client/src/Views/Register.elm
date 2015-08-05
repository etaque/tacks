module Views.Register where

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
  div [ class "register"]
    [ titleWrapper [ h1 [] [ text "Register" ] ]
    , div [ class "container"] [ registerForm t state.forms.register ]
    ]

registerForm : Translator -> RegisterForm -> Html
registerForm t form =
  div [ class "row form-login" ]
    [ whitePanel
      [ div [ class "form-group" ]
        [ label [] [ text "Handle" ]
        , textInput
          [ value form.handle
          , onInputFormUpdate (\s -> UpdateRegisterForm (\f -> { f | handle <- s } ))
          , onEnter submitMailbox.address (SubmitRegister form)
          ]
        ]
      , div [ class "form-group" ]
        [ label [] [ text "Email" ]
        , textInput
          [ placeholder "Email"
          , value form.email
          , onInputFormUpdate (\s -> UpdateRegisterForm (\f -> { f | email <- s } ))
          , onEnter submitMailbox.address (SubmitRegister form)
          ]
        ]
      , div [ class "form-group" ]
        [ label [] [ text "Password" ]
        , passwordInput
          [ value form.password
          , onInputFormUpdate (\s -> UpdateRegisterForm (\f -> { f | password <- s } ))
          , onEnter submitMailbox.address (SubmitRegister form)
          ]
        ]
      , div []
        [ button
          [ class "btn btn-primary btn-block"
          , onClick submitMailbox.address (SubmitRegister form)
          ]
          [ text "Submit" ]
        ]
      ]
    ]
