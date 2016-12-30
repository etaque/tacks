module Game.Widget.Controls exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Game.Msg exposing (..)
import View.Utils as Utils
import TouchEvents


view : Html GameMsg
view =
    div
        [ class "touch-commands" ]
        [ div
            [ class "touch-panel-left" ]
            [ a
                [ class "touch-left"
                , TouchEvents.onTouchStart (\_ -> Left True)
                , TouchEvents.onTouchEnd (\_ -> Left False)
                ]
                [ Utils.mIcon "keyboard_arrow_left" []
                , span [] [ text "left" ]
                ]
            , a
                [ class "touch-lock"
                , TouchEvents.onTouchStart (\_ -> LockWindAngle)
                ]
                [ Utils.mIcon "keyboard_arrow_down" []
                , span [] [ text "lock" ]
                ]
            ]
        , a
            [ class "touch-panel-center touch-tack"
            , TouchEvents.onTouchStart (\_ -> Tack)
            ]
            []
        , div
            [ class "touch-panel-right" ]
            [ a
                [ class "touch-right"
                , TouchEvents.onTouchStart (\_ -> Right True)
                , TouchEvents.onTouchEnd (\_ -> Right False)
                ]
                [ Utils.mIcon "keyboard_arrow_right" []
                , span [] [ text "right" ]
                ]
            , a
                [ class "touch-vmg"
                , TouchEvents.onTouchStart (\_ -> AutoVmg)
                ]
                [ Utils.mIcon "keyboard_arrow_up" []
                , span [] [ text "vmg" ]
                ]
            ]
        ]
