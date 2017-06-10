module Game.Render.Layer exposing (..)

import Html as H exposing (Html)
import Html.Attributes as HA
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Model.Shared exposing (..)


type alias Layer msg =
    { key : String
    , size : Size Int
    , rotation : Float
    , translation : Translation
    , content : Svg msg
    }


type alias Viewport =
    { size : Size Int
    , center : Position
    }


render : Viewport -> Layer msg -> Html msg
render { center, size } layer =
    let
        -- ( cx, cy ) =
        --     viewport.center
        -- ( vw, vh ) =
        --     viewport.size
        tx =
            layer.left + toFloat size.width / 2 - cx

        ty =
            -(layer.bottom + layer.height) + toFloat vh / 2 + cy

        layerViewBox =
            [ layer.left, layer.bottom, layer.width, layer.height ]
                |> List.map toString
                |> String.join " "
    in
        H.div
            [ HA.class ("svg-container " ++ layer.key)
            , width (toString layer.width)
            , height (toString layer.height)
            , HA.style
                [ ( "transform", translate3d tx ty 0 ++ " scale(1, -1)" )
                ]
            ]
            [ svg
                [ width (toString layer.width)
                , height (toString layer.height)
                , viewBox layerViewBox
                , version "1.1"
                ]
                [ layer.content ]
            ]


translate3d : Float -> Float -> Float -> String
translate3d x y z =
    "translate3d(" ++ toString x ++ "px," ++ toString y ++ "px,0)"
