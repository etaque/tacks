module View.DeviceControl exposing (view, icon)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import View.Utils as Utils
import Model.Shared exposing (..)
import Game.Msg exposing (..)


icon : DeviceControl -> String
icon deviceControl =
    case deviceControl of
        KeyboardControl ->
            "keyboard"

        TouchControl ->
            "tablet"

        UnknownControl ->
            "gamepad"


view : DeviceControl -> Html GameMsg
view deviceControl =
    div
        [ class "control-mode" ]
        [ div
            [ class "modes" ]
            [ div
                [ classList
                    [ ( "mode mode-keyboard", True )
                    , ( "chosen", deviceControl == KeyboardControl )
                    ]
                , onClick (ChooseControl KeyboardControl)
                ]
                [ Utils.mIcon "keyboard" []
                , span [] [ text "Keyboard" ]
                ]
            , div
                [ classList
                    [ ( "mode mode-touch", True )
                    , ( "chosen", deviceControl == TouchControl )
                    ]
                , onClick (ChooseControl TouchControl)
                ]
                [ Utils.mIcon "tablet" []
                , span [] [ text "Touch" ]
                ]
            ]
        , div
            [ class "help" ]
            [ case deviceControl of
                KeyboardControl ->
                    keyboardHelp

                TouchControl ->
                    touchHelp

                UnknownControl ->
                    text ""
            ]
        ]


keyboardHelp : Html msg
keyboardHelp =
    [ ( "left/right", "turn boat" )
    , ( "up", "lock to closest VMG" )
    , ( "down", "lock to curent wind angle" )
    , ( "space", "tack or jibe" )
    ]
        |> List.concatMap renderItem
        |> dl []


touchHelp : Html msg
touchHelp =
    [ ( "left/right", "turn boat" )
    , ( "up", "lock to closest VMG" )
    , ( "down", "lock to curent wind angle" )
    , ( "tap center", "tack or jibe" )
    ]
        |> List.concatMap renderItem
        |> dl []


renderItem : ( String, String ) -> List (Html msg)
renderItem ( keys, role ) =
    [ dt [] [ text keys ]
    , dd [] [ text role ]
    ]
