module Game.Widget.Controls exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Game.Msg exposing (..)
import View.Utils as Utils
import Game.Touch as Touch
import TouchEvents


view : Html GameMsg
view =
    div
        [ class "touch-commands" ]
        [ div
            [ class "touch-panel-left" ]
            [ a
                [ class "touch-left"
                , TouchEvents.onTouchStart (\_ -> TouchMsg (Touch.Turn -1))
                , TouchEvents.onTouchEnd (\_ -> TouchMsg (Touch.Turn 0))
                ]
                [ Utils.mIcon "chevron_left" []
                ]
            ]
        , div
            [ class "touch-panel-center" ]
            []
        , div
            [ class "touch-panel-right" ]
            [ a
                [ class "touch-right"
                , TouchEvents.onTouchStart (\_ -> TouchMsg (Touch.Turn 1))
                , TouchEvents.onTouchEnd (\_ -> TouchMsg (Touch.Turn 0))
                ]
                [ Utils.mIcon "chevron_right" []
                ]
            ]
        ]
