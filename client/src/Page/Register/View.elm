module Page.Register.View exposing (..)

import Dict exposing (Dict)
import String
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Form.Input as Input
import Form
import Model.Shared exposing (..)
import Page.Register.Model exposing (..)
import View.Utils exposing (..)
import View.Layout as Layout exposing (Layout)


view : Context -> Model -> Layout Msg
view ctx model =
    Layout
        "register"
        []
        (Just Layout.Register)
        [ Layout.header
            ctx
            []
            [ h1 [] [ text "Register" ]
            , div [ class "panel" ] [ Html.map FormMsg (registerForm model) ]
            ]
        ]
        Nothing


registerForm : Model -> Html Form.Msg
registerForm { form, loading, serverErrors } =
    let
        submitDisabled =
            Form.isSubmitted form

        getServerErrors field =
            Dict.get field serverErrors |> Maybe.withDefault []

        isFilled field =
            Maybe.map (String.isEmpty >> not) field.value |> Maybe.withDefault False

        group name label_ hint renderer =
            let
                field =
                    Form.getFieldAsString name form
            in
                fieldGroup
                    ("register_" ++ name)
                    label_
                    hint
                    (errList field.liveError ++ (getServerErrors name))
                    [ renderer
                        field
                        [ classList
                            [ ( "form-control", True )
                            , ( "filled", isFilled field )
                            ]
                        , id ("register_" ++ name)
                        ]
                    ]
    in
        div
            [ class "form-login" ]
            [ group
                "handle"
                "Handle"
                "Alphanumeric, at least 4 chars"
                Input.textInput
            , group
                "email"
                "Email"
                ""
                Input.textInput
            , group
                "password"
                "Password"
                ""
                Input.passwordInput
            , button
                [ class "btn-raised btn-primary btn-block"
                , onClick Form.Submit
                , disabled submitDisabled
                ]
                [ text "Submit" ]
            ]
