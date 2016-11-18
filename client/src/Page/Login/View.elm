module Page.Login.View exposing (..)

import String
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Page.Login.Model exposing (..)
import View.Utils exposing (..)
import View.Layout as Layout


view : Context -> Model -> Layout.Site Msg
view ctx model =
    Layout.Site
        "login"
        (Just Layout.Login)
        [ Layout.header
            ctx
            []
            [ h1 [] [ text "Login" ]
            , div [ class "panel" ] [ loginForm model ]
            ]
        ]
        Nothing


loginForm : Model -> Html Msg
loginForm { email, password, loading, error } =
    div
        [ class "form-login form-vertical" ]
        [ div
            [ class "form-group" ]
            [ input
                [ type_ "text"
                , value email
                , classList [ ( "form-control", True ), ( "filled", not (String.isEmpty email) ) ]
                , onInput SetEmail
                , onEnter Submit
                , id "login_email"
                ]
                []
            , label [ for "login_email" ] [ text "Email" ]
            ]
        , div
            [ class "form-group" ]
            [ input
                [ type_ "password"
                , value password
                , classList [ ( "form-control", True ), ( "filled", not (String.isEmpty password) ) ]
                , onInput SetPassword
                , onEnter Submit
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
                , onClick Submit
                ]
                [ text "Submit" ]
            ]
        ]


errorLine : Bool -> Html Msg
errorLine error =
    if error then
        p [ class "form-error-global" ] [ text "Login failure. Wrong credentials?" ]
    else
        text ""
