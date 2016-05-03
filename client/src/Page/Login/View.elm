module Page.Login.View (..) where

import String
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Page.Login.Model exposing (..)
import Page.Login.Update exposing (addr)
import View.Utils exposing (..)
import View.Layout as Layout


view : Context -> Model -> Html
view ctx model =
  Layout.siteLayout
    "login"
    ctx
    (Just Layout.Login)
    [ Layout.header
        ctx
        []
        [ h1 [] [ text "Login" ]
        , div [ class "panel" ] [ loginForm model ]
        ]
    ]


loginForm : Model -> Html
loginForm { email, password, loading, error } =
  div
    [ class "form-login form-vertical" ]
    [ div
        [ class "form-group" ]
        [ input
            [ type' "text"
            , value email
            , classList [ ( "form-control", True ), ( "filled", not (String.isEmpty email) ) ]
            , onInput addr SetEmail
            , onEnter addr Submit
            , id "login_email"
            ]
            []
        , label [ for "login_email" ] [ text "Email" ]
        ]
    , div
        [ class "form-group" ]
        [ input
            [ type' "password"
            , value password
            , classList [ ( "form-control", True ), ( "filled", not (String.isEmpty password) ) ]
            , onInput addr SetPassword
            , onEnter addr Submit
            , id "login_password"
            ]
            []
        , label [ for "login_password" ] [ text "Password" ]
        ]
    , errorLine error
    , div
        []
        [ button
            [ class "btn-raised btn-block btn-primary"
            , disabled loading
            , onClick addr Submit
            ]
            [ text "Submit" ]
        ]
    ]


errorLine : Bool -> Html
errorLine error =
  if error then
    p [ class "form-error-global" ] [ text "Login failure. Wrong credentials?" ]
  else
    text ""
