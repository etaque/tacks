module Page.EditTrack.View.Utils exposing (..)

import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import View.Utils as Utils exposing (..)
import Page.EditTrack.Model exposing (..)


intInput : number -> (Int -> FormMsg) -> List (Attribute FormMsg) -> Html FormMsg
intInput val formUpdate attrs =
    input
        ([ value (toString val)
         , onIntInput formUpdate
         , type_ "number"
         , class "form-control filled"
         ]
            ++ attrs
        )
        []
