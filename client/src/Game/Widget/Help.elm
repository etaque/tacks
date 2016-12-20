module Game.Widget.Help exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Html msg
view =
    let
        items =
            [ ( "left/right", "turn" )
            , ( "left/right + shift", "adjust" )
            , ( "up", "lock angle to wind" )
            , ( "space", "tack or jibe" )
            ]
    in
        div
            [ class "aside-module module-help" ]
            [ dl [] (List.concatMap renderItem items) ]


renderItem : ( String, String ) -> List (Html msg)
renderItem ( keys, role ) =
    [ dt [] [ text role ]
    , dd [] [ text keys ]
    ]
